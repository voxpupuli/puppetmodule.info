require_relative 'gem_store'

MOD_STORE_DB = Sequel.sqlite(REMOTE_MODS_FILE)
unless MOD_STORE_DB.table_exists?(:remote_modules)
  MOD_STORE_DB.create_table(:remote_modules) do
    primary_key :id
    string :name
    text :versions
  end
end

class RemoteModule < Sequel::Model(MOD_STORE_DB); end

class ModuleStore < GemStore
  private

  def source
    :remote_module
  end

  def model
    RemoteModule
  end
end
