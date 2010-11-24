# -*- encoding : utf-8 -*-
class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :village_id
      t.string :nom
      t.string :legend
      t.string :info
      t.string :url_originale
      t.boolean :actif

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
