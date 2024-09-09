#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

if __FILE__ == $0 then
  require 'optparse'
  require 'yaml'
  require_relative 'source-tree-diff-list'
  opt = OptionParser.new 
  opt.parse!(ARGV)

  a_path = ARGV[0]
  b_path = ARGV[1]

  a = SourceTreeDiffList.load(a_path)
  b = SourceTreeDiffList.load(b_path)

  a_contents = Hash.new
  a.list.each{|entry| a_contents[entry[0]]=entry}
  b_included_in_a_list = b.list.select{|entry| a_contents.key?(entry[0])}

  puts "contents: "
  if b_included_in_a_list.empty? then
    puts "# None"
  else
    b_included_in_a_list.each do |info|
      path    = info[0]
      exist_a = info[1]
      exist_b = info[2]
      if exist_a == true  and exist_b == true then
        puts(" - U: #{path}")
        next
      end
      if exist_a == false and exist_b == true then
        puts(" - A: #{path}")
        next
      end
      if exist_a == true  and exist_b == false then
        puts(" - D: #{path}")
        next
      end
    end
  end
end


