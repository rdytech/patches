require 'spec_helper'

# The install migration ships with the gem and consumers run it via
# `rake patches:install:migrations`, but nothing exercised it: it inherited from
# a bare ActiveRecord::Migration, which Rails has refused since 5.0.
describe 'db/migrate/201506011700_create_patch.rb' do
  let(:migration_path) do
    File.expand_path('../db/migrate/201506011700_create_patch.rb', __dir__)
  end

  it 'declares the Active Record release it was written for' do
    expect(File.read(migration_path)).to match(/ActiveRecord::Migration\[\d+\.\d+\]/)
  end

  it 'loads on the installed Rails version' do
    load migration_path
    expect(CreatePatch.superclass).to be < ActiveRecord::Migration
  end

  describe 'running it' do
    # Against a throwaway in-memory database, never the shared one: migrating
    # that would leave Patches::Patch holding column information for a table it
    # had just dropped, failing whichever spec ran next.
    around do |example|
      original = ActiveRecord::Base.connection_db_config
      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
      example.run
    ensure
      ActiveRecord::Base.establish_connection(original)
      Patches::Patch.reset_column_information
    end

    it 'creates the patches_patches table with a unique path index' do
      load migration_path
      CreatePatch.new.tap { |migration| migration.verbose = false }.migrate(:up)

      connection = ActiveRecord::Base.connection
      expect(connection.table_exists?(:patches_patches)).to be true
      expect(connection.columns(:patches_patches).map(&:name))
        .to include('path', 'created_at', 'updated_at')

      path_index = connection.indexes(:patches_patches).find { |index| index.columns == ['path'] }
      expect(path_index).not_to be_nil
      expect(path_index.unique).to be true
    end
  end
end
