# -*- encoding : utf-8 -*-
class CreateCartes < ActiveRecord::Migration
  def self.up
    create_table :cartes do |t|
      t.string :nom
      t.string :info
      t.integer :village_id
      t.string :url_originale

      t.timestamps
    end
  end

  def self.down
    drop_table :cartes
  end
end
