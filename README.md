PuppetModule.info: Puppet Strings Doc Server
============================================

PuppetModule.info is the next generation Puppet module doc server.

This doc server uses YARD to generate project documentation on the fly, for
both published Puppet modules as well as GitHub projects.

The public doc server is hosted at [http://www.rubydoc.info](http://www.rubydoc.info)

It relies on:

* [Puppet Strings](https://github.com/puppetlabs/puppet-strings)
* [RubyDoc.info](https://github.com/docmeta/rubydoc.info)
* [YARD](https://github.com/lsegal/yard)

Getting Started
---------------

This site is a public service and is community-supported. Patches and
enhancements are welcome.

Running the doc server locally is easy:

```
$ git clone git://github.com/domcleal/puppetmodule.info
$ cd puppetmodule.info
$ bundle install
$ rake gems:update
$ rackup config.ru
```

Thanks
------

PuppetModule.info is maintained by Dominic Cleal, and is unaffiliated to Puppet.
RubyDoc.info was created by Loren Segal (YARD) and Nick Plante (rdoc.info) and is a project of DOCMETA, LLC.
Additional help was provided by [YARD's friendly developer community](https://github.com/lsegal/rubydoc.info/graphs/contributors).
Pull requests welcome!

(c) 2015 DOCMETA LLC, 2017 Dominic Cleal. This code is distributed under the MIT license.
