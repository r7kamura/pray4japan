class ChangeColumnImagesCaption < ActiveRecord::Migration
  def self.up
    change_column :images, :caption, :text
  end

  def self.down
    change_column :images, :caption, :string
  end
end
