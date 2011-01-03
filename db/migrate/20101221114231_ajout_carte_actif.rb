class AjoutCarteActif < ActiveRecord::Migration
  def self.up
    add_column :cartes, :actif, :boolean, {:default=>true}
  end

  def self.down
  end
end
