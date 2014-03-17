require 'securerandom'
namespace :secret do
  desc "generate secrets.yml"
  task :yml => :environment do
    sekrets=%w{ development test production }.inject({}) do |hsh,env_name|
      hsh[env_name]={"secret_key_base" => SecureRandom.hex(64) }
      hsh
    end
    puts sekrets.to_yaml
  end
end
