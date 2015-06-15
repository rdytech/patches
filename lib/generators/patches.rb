module Patches
  module Generators
    class PatchGenerator < Rails::Generators::NamedBase
      desc 'Adds an empty patch'
      source_root File.expand_path('../templates', __FILE__)

      def generate_patch
        template "patch.erb", "app/db/#{file_name}.rb"
      end

      private

      def class_name
        name.camelize
      end

      def file_name
        name.underscore
      end
    end
  end
end
