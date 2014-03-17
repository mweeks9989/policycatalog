#secrets.rb
module Policycatalog
  class Application < Rails::Application
  	secrets=YAML.load(File.read(File.join(Rails.root, 'config', 'secrets.yml')))
    config.secret_key_base=secrets[Rails.env]["secret_key_base"]
  end
end