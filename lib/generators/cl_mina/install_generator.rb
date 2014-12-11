require 'rails/generators'

module ClMina
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates deploy configuration files."

      def copy_deploy_rb
        template "deploy.rb", "config/deploy.rb"
      end

      def copy_deploy_environments
        template "staging.rb", "config/deploy/staging.rb"
        template "production.rb", "config/deploy/production.rb"
      end

      def copy_defaults
        template "defaults.rb", "config/deploy/defaults.rb"
      end

      def create_staging_environment
        copy_file "#{Rails.root}/config/environments/production.rb", "config/environments/staging.rb"
      end
    end
  end
end
