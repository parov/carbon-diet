APP_CONFIG = HashWithIndifferentAccess.new YAML.load_file("#{RAILS_ROOT}/config/settings.yml")[RAILS_ENV]