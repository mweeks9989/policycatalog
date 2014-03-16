require 'sqlite3'
require 'pg'
require 'active_record'
require 'json'

namespace :sites do
  namespace :dump do
    desc "dump sqlite db entries"
    task :legacy do 
      db_path=ENV['DB_PATH']
      class Category < ActiveRecord::Base
        has_many :entries
      end
      class Entry < ActiveRecord::Base
        belongs_to :category
        def exp_comment
          if comment.nil? || comment==""
            "bulk export from legacy"
          else
            comment
          end
        end
        def to_h
          { 
            category:   category.name, 
            uri:        url, 
            comment:    exp_comment,
            created_by: created_by,
            created_at: created_on 
          }
        end
      end
      ActiveRecord::Base.establish_connection( 
        adapter: 'sqlite3', database: db_path 
      )

      jsons = Entry.all.map {|e| JSON.generate(e.to_h) }
      puts "[", jsons.join(",\n"), "]"
    end
  end
end
