class AjoutDefautVillageActif < ActiveRecord::Migration
  def self.up
    change_column :villages, :actif, :boolean, {:default=>true}
  end

  def self.down
  end
end
