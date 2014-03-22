class CreateWigiWikis < ActiveRecord::Migration
  def self.up
    create_table :wigi_wikis do |t|
      t.references :project
      t.string  :git_path
      t.string  :default_page,:default=>'index'
      t.string  :directory, :default => 'doc/'
      t.string  :ext,       :default => '.txt'
      t.string  :branch,    :default => 'master'
      t.boolean :is_bare,   :default => true
      t.boolean :is_fs,     :default => false
    end
  end
  def self.down
    drop_table :wigi_wikis
  end
end
