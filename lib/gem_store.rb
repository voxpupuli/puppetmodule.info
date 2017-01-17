require 'sequel'
require 'base64'
require 'version_sorter'
require_relative 'extensions'

GEM_STORE_DB = defined?(DATABASE_URL) ? Sequel.connect(DATABASE_URL) : Sequel.sqlite(REMOTE_GEMS_FILE)
unless GEM_STORE_DB.table_exists?(:remote_gems)
  GEM_STORE_DB.create_table(:remote_gems) do
    primary_key :id
    String :name
    String :versions, text: true
  end
end

class RemoteGem < Sequel::Model(GEM_STORE_DB); end

class GemStore
  include Enumerable

  def [](name) to_versions(model.first(name: name)) end
  def []=(name, versions)
    versions = versions.split(' ') if versions.is_a?(String)
    versions = versions.map {|v| v.is_a?(YARD::Server::LibraryVersion) ? v.version : v }
    versions = VersionSorter.sort(versions)
    if model.where(name: name).count > 0
      model.first(name: name).update(versions: versions.join(" "))
    else
      model.create(name: name, versions: versions.join(" "))
    end
  end

  def delete(name)
    model.where(name: name).delete
  end

  def has_key?(name) !!model.first(name: name) end
  def each(&block) model.each {|row| yield row.name, to_versions(row) } end
  def size; model.count end
  def empty?; size == 0 end

  def each_of_letter(letter, &block)
    return enum_for(:each_of_letter, letter) unless block_given?

    model.where(Sequel.like(:name, "#{letter}%")).each do |row|
      yield row.name, to_versions(row)
    end
  end

  def find_by(search)
    return enum_for(:find_by, search) unless block_given?

    model.where(Sequel.like(:name, "%#{search}%")).each do |row|
      yield row.name, to_versions(row)
    end
  end

  def keys; model.all.map(&:name) end
  def values; model.all.map {|r| to_versions(r) } end

  private

  def to_versions(row)
    return nil unless row
    row.versions.split(" ").map do |v|
      ver, platform = *v.split(',')
      lib = YARD::Server::LibraryVersion.new(row.name, ver, nil, source)
      lib.platform = platform
      lib
    end
  end

  def source
    :remote_gem
  end

  def model
    RemoteGem
  end
end
