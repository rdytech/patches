module Patches
  module Generators
    class PatchGenerator < Rails::Generators::NamedBase
      desc 'Adds an empty patch'
      source_root File.expand_path('../templates', __FILE__)

      class_option :specs, type: :boolean, default: false, description: 'Generates a rspec file for the patch'

      def generate_patch
        template "patch.rb.erb", "db/patches/#{file_name}.rb"
        template "patch_spec.rb.erb", "spec/patches/#{file_name}_spec.rb" if options['specs']
      end

      private

      def class_name
        name.camelize
      end

      def file_name
        "#{Time.now.strftime('%Y%m%d%H%M')}_#{name.underscore}"
      end
    end
  end
end

