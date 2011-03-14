class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :thumb_url
      t.string :image_url
      t.string :link
      t.integer :image_id
      t.string :caption
      t.string :user
      t.string :user_picture_url
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
