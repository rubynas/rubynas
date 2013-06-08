class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
