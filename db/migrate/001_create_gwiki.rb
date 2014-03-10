class CreateGwikiWikis < ActiveRecord::Migration
  def self.up
    create_table :gwiki_wikis do |t|
      t.references :project
      t.string :git_path
      t.string :directory, :default => 'doc'
      t.bool :is_bare, :default => true
    end
  end
  def self.down
    drop_table :gwiki_wikis
  end
end
