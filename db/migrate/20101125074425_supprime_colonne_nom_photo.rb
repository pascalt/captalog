class SupprimeColonneNomPhoto < ActiveRecord::Migration
  def self.up
    remove_column :photos, :nom
  end

  def self.down
  end
end
