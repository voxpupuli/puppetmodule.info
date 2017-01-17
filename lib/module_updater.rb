require_relative 'cache'
require_relative 'module_store'
require 'puppet_forge'
require 'version_sorter'
require 'yard'

PuppetForge.user_agent = 'PuppetModule.info (github.com/domcleal/puppetmodule.info/issues)'

class ModuleVersion
  attr_accessor :name, :version
  alias_method :to_s, :version

  def initialize(name, version)
    @name, @version = name.to_s, version.to_s
  end

  def ==(other)
    self.name == other.name && self.version == other.version
  end
end

class ModuleUpdater
  include YARD::Server

  attr_accessor :mod, :settings, :app

  class << self
    def fetch_remote_modules
      libs = {}
      module_enum = PuppetForge::Module.where(sort_by: 'latest_release')
      # If MODULE_UPDATER_LIMIT is set, only load the first page of data (for development)
      module_enum = module_enum.unpaginated unless ENV.has_key?('MODULE_UPDATER_LIMIT')
      module_enum.each do |mod|
        libs[mod.slug] = mod.releases.map do |release|
          ModuleVersion.new(mod.slug, release.version)
        end
      end
      libs
    end

    def update_remote_modules
      libs = fetch_remote_modules
      store = ModuleStore.new
      changed_modules = {}
      removed_modules = []
      RemoteModule.all.each do |row|
        changed_modules[row.name] = row.versions.split(' ')
      end

      RemoteModule.db.transaction do
        libs.each do |name, versions|
          versions = pick_best_versions(versions)
          if changed_modules[name] && (versions|changed_modules[name]).size == versions.size
            changed_modules.delete(name)
          elsif changed_modules[name]
            store[name] = versions
          else
            RemoteModule.create(name: name,
              versions: VersionSorter.sort(versions).join(" "))
          end
        end
      end

      changed_modules.keys.each do |module_name|
        flush_cache(module_name)
      end

      # deal with deleted modules
      changed_modules.keys.each do |module_name|
        next if libs[module_name]
        removed_modules << module_name
        changed_modules.delete(module_name)
        store.delete(module_name)
      end

      [changed_modules, removed_modules]
    end

    def pick_best_versions(versions)
      seen = {}
      uniqversions = []
      versions.each do |ver|
        uniqversions |= [ver.version]
        (seen[ver.version] ||= []).unshift ver
      end
      uniqversions.map {|v| seen[v].first.to_s }
    end

    def flush_cache(module_name)
      Cache.invalidate("/modules", "/modules/~#{module_name[0, 1]}", "/modules/#{module_name}")
    end
  end

  def initialize(app, name, version)
    self.settings = app.settings
    self.app = app
    self.mod = ModuleVersion.new(name, version)
  end

  def register
    puts "Registering module #{mod.name}-#{mod.version}"
    store = ModuleStore.new
    libs = (store[mod.name] || []).map {|v| v.version }
    store[mod.name] = libs | [mod.version]
  end

  # TODO: improve this cache invalidation to be version specific
  def flush_cache
    self.class.flush_cache(mod.name)
  end
end
