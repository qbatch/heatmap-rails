require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/base'

module HeatmapRails
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_model_file
      migration_template "initializer.rb", "db/migrate/create_heat_maps.rb"
    end
  end
end
