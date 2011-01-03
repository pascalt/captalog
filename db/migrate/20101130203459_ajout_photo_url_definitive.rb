# -*- encoding : utf-8 -*-
class AjoutPhotoUrlDefinitive < ActiveRecord::Migration
  def self.up
    add_column :photos, :url_definitive, :string
  end

  def self.down
    remove_column :photos, :url_definitive
  end
end
