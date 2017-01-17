class Configuration < Hash
  def self.load
    config = Configuration.new

    [CONFIG_DIST, CONFIG_FILE].each do |config_file|
      if File.file?(config_file)
        (YAML.load_file(config_file) || {}).each do |key, value|
          config[key] = value
          define_method(key) { self[key] }
        end
      end
    end

    config
  end

  def method_missing(name, *args, &block)
    self[name]
  end
end
