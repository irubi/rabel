class CreateNicepictures < ActiveRecord::Migration
  def change
    create_table :nicepictures do |t|
      t.string :url
      t.integer :topic_id

      t.timestamps
    end
  end
end
