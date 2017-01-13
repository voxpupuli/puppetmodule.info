#!/usr/bin/env ruby
#
# Rewrite of the "puppet strings" face to look more like "yardoc".
# The root module for Puppet Strings.

require 'puppet-strings'

PuppetStrings.generate(PuppetStrings::DEFAULT_SEARCH_PATTERNS, :yard_args => ARGV)
