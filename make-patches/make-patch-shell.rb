#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'yaml'
require_relative 'source-tree-diff-list'

class MakePatchShell

  VERSION = "0.1.0"

  class SourceGroup
    attr_reader :name
    attr_reader :pattern_list
    attr_reader :file_list
    def initialize(name, pattern_list)
      @name         = name
      @pattern_list = pattern_list.map{|pattern| Regexp.new(pattern)}
      @file_list    = Array.new
    end
    def hit(path)
      hit=false
      @pattern_list.each do |pattern|
        if pattern.match?(path) then
          hit=true
          break
        end
      end
      return hit
    end
    def add_path_if_hit(path)
      if hit(path) then
        @file_list.push(path)
        return true
      else
        return false
      end
    end
  end

  attr_reader :old_name
  attr_reader :new_name
  attr_reader :diff_name
  attr_reader :diff_list
  attr_reader :diff_dict
  attr_reader :group_dict
  def initialize(diff_file_name, patch_group_file)
    @diff_list  = SourceTreeDiffList.load(diff_file_name)
    @old_name   = @diff_list.a_name
    @new_name   = @diff_list.b_name
    @diff_name  = @diff_list.name
    @diff_dict  = Hash.new
    add_diff_dict(@diff_list.list)
    @group_dict = Hash.new
    load_group(patch_group_file)
    add_group("other" , [".*"])
    add_path_to_group_dict()
  end

  def load_group(file_name)
    info = YAML.load_file(file_name)
    group = info["group"].each_pair do |name, pattern_list|
      add_group(name, pattern_list.map{|pattern| "^#{pattern}"})
    end
  end
  
  def add_group(name, pattern_list)
    if @group_dict.key?(name) then
      @group_dict[name].pattern_list.concat(pattern_list)
    else
      @group_dict[name] = SourceGroup.new(name, pattern_list)
    end
  end

  def add_diff_dict(diff_list)
    diff_list.each do |entry|
      path = entry[0]
      @diff_dict[path] = entry
    end
  end

  def add_path_to_group_dict
    @diff_dict.each_pair do |path, info|
      @group_dict.each_pair do |name, group|
        if group.add_path_if_hit(path) then
          break;
        end
      end
    end    
  end

  def print_group_dict
    @group_dict.each_pair do |name, group|
      printf("%s: \n", name)
      group.file_list.each do |path|
        info = @diff_dict[path]
        printf("  - %-80s %s %s \n", path, info[1], info[2])
      end
    end
  end

  def make_shell_script(file, patch_dir)
    patch_file_name = "PATCH_FILE"
    patch_list = Array.new
    @group_dict.each_pair do |name, group|
      next if group.file_list.empty?
      patch_info = {name: "#{name}.patch", diff_list: Array.new}
      group.file_list.each do |path|
        info = @diff_dict[path]
        if info[1] == true then
          a_path = "#{@old_name}/#{path}"
          b_path = "#{@new_name}/#{path}"
        else
          a_path = "#{@old_name}/#{path} --label=/dev/null"
          b_path = "#{@new_name}/#{path}"
        end
        patch_info[:diff_list].push({a: a_path, b: b_path})
      end
      patch_list.push(patch_info)
    end
    a_path_name_max = 20
    b_path_name_max = 20
    patch_list.each do |patch_info|
      patch_info[:diff_list].each do |path_pair|
        a_path_name_max = [a_path_name_max, path_pair[:a].length].max
        b_path_name_max = [b_path_name_max, path_pair[:b].length].max
      end
    end
    diff_command_format = sprintf("diff -urN %%-%ds %%-%ds >>$%s \n", a_path_name_max, b_path_name_max, patch_file_name)
    file.puts("PATCH_DIR=#{patch_dir}")
    file.puts("install -d $PATCH_DIR")
    file.puts("")
    patch_list.each do |patch_info|
      name = patch_info[:name]
      file.puts("#{patch_file_name}=$PATCH_DIR/#{name}")
      file.puts("echo -n >| $#{patch_file_name}")
      file.puts("")
      patch_info[:diff_list].each do |path_pair|
        file.printf(diff_command_format, path_pair[:a], path_pair[:b])
      end
      file.puts("")
    end
    file.puts("")
    patch_script_header = <<~'EOT'
      PATCH_DIR=$(cd $(dirname $0); pwd)
      dry_run=0
      verbose=1
      
      run_command()
      {
          if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
      	echo "$1"
          fi
          if [ $dry_run -eq 0 ]; then
      	eval "$1"
          fi
      }
      
      run_patch()
      {
          if [ $dry_run -ne 0 ] || [ $verbose -ne 0 ]; then
      	echo "## patch ${PATCH_DIR}/${1}"
          fi
          run_command "patch -p1 < ${PATCH_DIR}/${1}"
          run_command "git add --all"
          run_command "git commit -m '[patch] ${1}'"
      }
      
    EOT
    file.puts("cat << 'EOT' > $PATCH_DIR/xxx_patch.sh")
    file.puts(patch_script_header)
    patch_list.each do |patch_info|
      name = patch_info[:name]
      file.puts("run_patch #{name}")
    end
    file.puts("EOT")

  end
    
end

if __FILE__ == $0 then
  require 'optparse'
  diff_file_name    = nil
  group_file_name   = nil
  shell_script_name = nil
  do_print = false
  opt = OptionParser.new 
  opt.program_name = "make-patch-shell.rb"
  opt.version      = MakePatchShell::VERSION
  opt.banner       = <<~EOT
      Usage: #{opt.program_name} [Options]"
      Description: This script generates a shell script to create a patch file from a file describing the differences in the source tree.
      Options: 
  EOT
  opt.on('-d', '--diff-file  FILE', 'File generated by source-tree-diff-list.rb'){|val| diff_file_name    = val}
  opt.on('-g', '--group-file FILE', 'File describing a group of source tree'    ){|val| group_file_name   = val}
  opt.on('-s', '--shell NAME'     , 'File name of the shell script to generate' ){|val| shell_script_name = val}
  opt.on('-p', '--print'          ){do_print = true}

  opt.parse!(ARGV)
  if diff_file_name.nil? then
    puts "Error: The file generated by source-tree-diff-list.rb is not specified."
    puts opt
    abort
  end
  if group_file_name.nil? then
    puts "Error: The file describing the source tree group is not specified."
    puts opt
    abort
  end
  mkpatch = MakePatchShell.new(diff_file_name, group_file_name)
  if do_print == true then
    mkpatch.print_group_dict()
  end
  if !shell_script_name.nil? then
    open(shell_script_name, 'w') do |file|
      mkpatch.make_shell_script(file, "./patches/#{mkpatch.diff_name}")
    end
  end
end
