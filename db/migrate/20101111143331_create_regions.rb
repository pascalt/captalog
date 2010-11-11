# coding: utf-8
class CreateRegions < ActiveRecord::Migration
  def self.up
    create_table :regions do |t|
      t.string :nom
      t.string :code
      t.string :nc

      t.timestamps
    end
    Region.create :code=>"42", :nom=>"Alsace"
    Region.create :code=>"72", :nom=>"Aquitaine"
    Region.create :code=>"83", :nom=>"Auvergne"
    Region.create :code=>"25", :nom=>"Basse-Normandie"
    Region.create :code=>"26", :nom=>"Bourgogne"
    Region.create :code=>"53", :nom=>"Bretagne"
    Region.create :code=>"24", :nom=>"Centre"
    Region.create :code=>"21", :nom=>"Champagne-Ardenne"
    Region.create :code=>"94", :nom=>"Corse"
    Region.create :code=>"43", :nom=>"Franche-Comté"
    Region.create :code=>"23", :nom=>"Haute-Normandie"
    Region.create :code=>"11", :nom=>"Île-de-France"
    Region.create :code=>"91", :nom=>"Languedoc-Roussillon"
    Region.create :code=>"74", :nom=>"Limousin"
    Region.create :code=>"41", :nom=>"Lorraine"
    Region.create :code=>"73", :nom=>"Midi-Pyrénées"
    Region.create :code=>"31", :nom=>"Nord-Pas-de-Calais"
    Region.create :code=>"52", :nom=>"Pays-de-la-Loire"
    Region.create :code=>"22", :nom=>"Picardie"
    Region.create :code=>"54", :nom=>"Poitou-Charentes"
    Region.create :code=>"93", :nom=>"Provence-Alpes-Côte d'Azur"
    Region.create :code=>"82", :nom=>"Rhône-Alpes"
  end

  def self.down
    drop_table :regions
  end
end
