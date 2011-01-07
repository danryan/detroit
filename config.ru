$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'bundler'

Bundler.require

require 'app'
run Detroit::App