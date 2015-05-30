APP_CONFIGS = YAML.load_file("#{Rails.root.to_s}/config/app_config.yml")[Rails.env]

Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
