#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'

class SourceTreeDiffList

  VERSION = "0.1.0"

  attr_reader :name
  attr_reader :a_name, :a_path
  attr_reader :b_name, :b_path
  attr_reader :file_name
  attr_reader :list
  attr_reader :debug
  def initialize(name, a_name=nil, b_name=nil)
    @name      = name
    @a_name    = a_name
    @a_path    = nil
    @b_name    = b_name
    @b_path    = nil
    @file_name = "diff-#{name}.txt"
    @list      = Array.new
    @debug     = 0
  end

  def make(a_path, b_path)
    diff_lines  = `diff -r -q #{a_path}/ #{b_path}/`
    if @debug > 0 then
      puts("## #{diff_lines}")
    end
    diff_lines.each_line do |line|
      line.chop()
      if (line =~ /\.git/) then
        next
      end
      if (line =~ /scripts\/dtc\/include-prefixes\//)
        next
      end
      if @debug > 0 then
        puts("## #{line}")
      end
      if (line =~ /^Files\s+(\S+)\s+and\s+(\S+)\s+differ$/) then
        path = $2.gsub(/^#{b_path}\//,'')
        @list.push([path, true , true ])
        next
      end
      if (line =~ /^Only in #{b_path}\/(.*):\s+(.*)$/) then
        path = "#{$1}/#{$2}"
        if FileTest.directory? "#{b_path}/#{path}" then
          path="#{path}/"
        end
        @list.push([path, false, true ])
        next
      end
      if (line =~ /^Only in #{a_path}\/(.*):\s+(.*)$/) then
        path = "#{$1}/#{$2}"
        if FileTest.directory? "#{a_path}/#{path}" then
          path="#{path}/"
        end
        @list.push([path, true , false])
        next
      end
    end
    @a_path = a_path
    @b_path = b_path
    @a_name = File.basename(a_path) if @a_name.nil?
    @b_name = File.basename(b_path) if @b_name.nil?
  end

  def self.load(file_name)
    return self.new(nil)._load(file_name)
  end

  def _load(file_name)
    info = YAML.load_file(file_name)
    @name     = info["name"]
    @a_name   = info["a"]["name"]
    @a_path   = info["a"]["path"]
    @b_name   = info["b"]["name"]
    @b_path   = info["b"]["path"]
    @file_name= file_name
    @list     = Array.new
    info["contents"].each do |command|
      if command.key?("U") then
        @list.push([command["U"], true , true ])
        next
      end
      if command.key?("A") then
        @list.push([command["A"], false, true ])
        next
      end
      if command.key?("D") then
        @list.push([command["D"], true , false])
        next
      end
    end
    return self
  end

  def _save(file, file_name)
    file.puts("---")
    file.puts("name: #{@name}")
    file.puts("file: #{file_name}")
    file.puts("a:    {name: #{@a_name}, path: #{a_path}} ")
    file.puts("b:    {name: #{@b_name}, path: #{b_path}} ")
    file.puts("contents:")
    @list.each do |info|
      path    = info[0]
      exist_a = info[1]
      exist_b = info[2]
      if exist_a == true  and exist_b == true then
        file.puts(" - U: #{path}")
        next
      end
      if exist_a == false and exist_b == true then
        file.puts(" - A: #{path}")
        next
      end
      if exist_a == true  and exist_b == false then
        file.puts(" - D: #{path}")
        next
      end
    end
    return self
  end

  def save(file_name=nil)
    file_name = @file_name if file_name.nil? 
    File.open(file_name,"w") do |file|
      _save(file, file_name)
    end
  end
end

if __FILE__ == $0 then
  require 'optparse'
  verbose  = false
  title    = nil
  a_name   = nil
  b_name   = nil
  out_file = nil
  opt = OptionParser.new 
  opt.program_name = "source-tree-diff-list.rb"
  opt.version      = SourceTreeDiffList::VERSION
  opt.banner       = <<~EOT
      Usage: #{opt.program_name} [Options] a_path b_path"
      Description: This script compares two source trees and extracts different files.
      Options: 
  EOT
  opt.on('-T', '--title   NAME', 'Title of the resulting output'){|val| title    = val }
  opt.on('-A', '--a-name  NAME', 'Name of a_path'               ){|val| a_name   = val }
  opt.on('-B', '--b-name  NAME', 'Name of b_path'               ){|val| b_name   = val }
  opt.on('-o', '--out     PATH', 'Output the results as a Yaml format file'){|val| out_file = val }
  opt.on('-v', '--verbose'){|val| verbose  = true}
  opt.on('-h', '--help'   ){|val| puts opt; exit }
  opt.parse!(ARGV)

  a_path = ARGV[0]
  b_path = ARGV[1]

  if a_path.nil? or b_path.nil? then
    puts opt
    abort
  end

  a_name = File.basename(a_path) if a_name.nil?
  b_name = File.basename(b_path) if b_name.nil?

  title = "#{a_name}-#{b_name}" if title.nil?

  if verbose == true then
    puts("## #{opt.program_name} #{opt.version}")
    puts("## NAME: #{title}")
    puts("## A   : {name: #{a_name}, path: #{a_path}}")
    puts("## B   : {name: #{b_name}, path: #{b_path}}")
    puts("## OUT : #{out_file}") if !out_file.nil?
  end

  diff_list = SourceTreeDiffList.new(title, a_name, b_name)
  diff_list.make(a_path, b_path)
  if out_file.nil? then
    diff_list._save(STDOUT, "--")
  else
    diff_list.save(out_file)
  end
end
