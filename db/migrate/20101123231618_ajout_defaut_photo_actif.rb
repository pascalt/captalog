class AjoutDefautPhotoActif < ActiveRecord::Migration
  def self.up
    change_column :photos, :actif, :boolean, {:default=>true}
  end

  def self.down
  end
end
