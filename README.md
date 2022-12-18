PuppetModule.info: Puppet Strings Doc Server
============================================

PuppetModule.info is the next generation Puppet module doc server.

This doc server uses YARD to generate project documentation on the fly, for
both published Puppet modules as well as GitHub projects.

The public doc server is hosted at [http://puppetmodule.info](http://puppetmodule.info)

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
git clone git://github.com/voxpupuli/puppetmodule.info
cd puppetmodule.info
bundle install --path .vendor --jobs $(nproc)
rake gems:update
bundle exec puma --config config/puma.rb
```

Rake tasks
----------

Important rake tasks for deployment:

* `rake modules:update MODULE_UPDATER_PARTIAL=true` - run regularly (hourly)
  to scrape the latest module releases from Puppet Forge.
* `rake modules:update` - run infrequently (daily) to check all known Forge
  modules, for deletions etc.

For development:

* `rake modules:update MODULE_UPDATER_LIMIT=true` - import only the first page
  of Forge modules for a small dataset, fast and reduces load.

Thanks
------

PuppetModule.info was maintained by Dominic Cleal, and is unaffiliated to Puppet.
RubyDoc.info was created by Loren Segal (YARD) and Nick Plante (rdoc.info) and is a project of DOCMETA, LLC.
Additional help was provided by [YARD's friendly developer community](https://github.com/lsegal/rubydoc.info/graphs/contributors).

Dominic run the site for years, until he migrated it to Vox Pupuli.
Pull requests welcome!

(c) 2015 DOCMETA LLC, 2017 Dominic Cleal, 2022 Vox Pupuli. This code is distributed under the MIT license.
