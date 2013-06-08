class CreateSharedFolders < ActiveRecord::Migration
  def change
    create_table :shared_folders do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
