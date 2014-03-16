require 'rake'
require 'json'
require 'pry'

def options_from_hash(hsh)
  {
    created_at: Chronic.parse(hsh["created_at"]),
    created_by: hsh["created_by"],
    uri:        hsh["uri"],
    comment:    hsh["comment"],
    policy:     'production'
  }
end

def find_or_create(hsh)
  if site=Site.find_by_uri(hsh["uri"])
    site
  else
    Site.create(options_from_hash(hsh))
  end
end

def exported_data
  filename = ENV.fetch('SITES_JSON','db/data/entries.json')
  JSON.parse(File.read(filename))
end

namespace :sites do
  namespace :load do
    desc "load json formatted sites into current db"
    task json: :environment do 
      Site.destroy_all 
      created = exported_data.map do |site_hash| 
        site = find_or_create(site_hash)
        site.categorize_by_name(site_hash["category"])
        site
      end
      errors  = created.select {|c| c.errors.messages != {} }
      binding.pry
    end
  end
end
