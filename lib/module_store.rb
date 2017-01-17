require_relative 'gem_store'

MOD_STORE_DB = defined?(DATABASE_URL) ? Sequel.connect(DATABASE_URL) : Sequel.sqlite(REMOTE_MODS_FILE)
unless MOD_STORE_DB.table_exists?(:remote_modules)
  MOD_STORE_DB.create_table(:remote_modules) do
    primary_key :id
    String :name
    String :versions, text: true
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
