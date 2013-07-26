#!/usr/bin/env ruby

# The MIT License (MIT)
# 
# Copyright (c) 2013 Matt Okeson-Harlow
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ruby 2.0
# script to generate png qrcodes from a BitTorrent Sync config file

require 'json'
require 'rqrcode'
require 'rqrcode_png'
require 'optparse'

# Development Environment:
# rvm 1.20.13 (stable), https://rvm.io
# Ruby 2.0
# gem install rqrcode
# gem install rqrcode_png

# two optional arguments, an input file specified with --file
# an image size specified with --size.
# --file defaults to '.btsync'
# --size defaults to 300

options = {}

opts = OptionParser.new do |opts|
  opts.banner = "Usage: btsync_qrcode.rb [options]"

  # set defaults
  options[:file] = "~/.btsync"
  options[:size] = 300

  opts.on( '-f', '--file FILE', 'BTSync config file ( default ~/.btsync )' ) do |f|
    options[:file] = f
  end

  # force this option to be an Integer, otherwise it defaults to a string
  opts.on( '-s', '--size SIZE', Integer, 'PNG image size (default 300)' ) do |s|
    options[:size] = s
  end
end.parse!

# check to see if our BTSync configration file exists
# use File.expand_path so that ~/ is interpreted
if File.file?( File.expand_path options[:file] ) then

  # Open the input file, read the contents into a variable.
  inputfile = File.open( File.expand_path options[:file], "r")
  contents = inputfile.read

  # parse the file using JSON
  parsed = JSON.parse( contents )

  # step through the shared_folders definitions
  parsed["shared_folders"].each do |folder|
    # convert the dir to a string
    directory = folder['dir'].to_s

    # get the last directory in the path
    name = directory.split('/').last

    # add .png to the name to make our image filename
    filename = name + '.png'

    # string that will be turned into the qrcode
    # found using the Barcode Scanner app on an Android Phone on an offial
    # BTSync windows app
    qrstring = 'btsync://' + folder['secret'] + '?n=' + name

    # default size is 4, trial and error to go to 7, need to figure out how to
    # get to this based on the length of the qrstring.
    qr = RQRCode::QRCode.new( qrstring, :size => 7 )

    # convert qr to image.
    png = qr.to_img

    # print a table of what directory goes with what image.
    puts "Share: #{directory} => #{filename}"

    # save out the png file, resizing it.
    png.resize( options[:size], options[:size] ).save( filename )
  end
else
  # error message in case file does not exist.
  puts "File #{options[:file]} does not exist"
end

# vim: ai:et:sts=2:ft=ruby:ts=2:sw=2
