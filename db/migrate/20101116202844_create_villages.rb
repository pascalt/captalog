# -*- encoding : utf-8 -*-
class CreateVillages < ActiveRecord::Migration
  def self.up
    create_table :villages do |t|
      t.string :article
      t.string :nom_sa
      t.string :nc
      t.string :longitude
      t.string :latitude
      t.integer :region_id
      t.integer :departement_id
      t.string :type_village
      t.string :rue
      t.string :cp
      t.string :ville
      t.boolean :actif
      t.datetime :date_entree
      t.datetime :date_sortie

      t.timestamps
    end
    Village.create(:id => 0, :nom_sa =>"Cap France", :nc => "capfrance", :type_village => "fédé" )
  end

  def self.down
    drop_table :villages
  end
end
