# -*- encoding : utf-8 -*-
class AjoutDuEDeLegendePhoto < ActiveRecord::Migration
  def self.up
    rename_column :photos, :legend, :legende
  end

  def self.down
  end
end
