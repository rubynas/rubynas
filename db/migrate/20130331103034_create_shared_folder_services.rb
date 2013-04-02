class CreateSharedFolderServices < ActiveRecord::Migration
  def change
    create_table :shared_folder_services do |t|
      t.references :shared_folder
      t.string :service_class
      t.text :options

      t.timestamps
    end
  end
end
