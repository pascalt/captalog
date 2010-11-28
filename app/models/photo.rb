# -*- encoding : utf-8 -*-
class Photo < ActiveRecord::Base
  belongs_to :village
  
  validates_presence_of :village_id
  validates :url_originale, :presence => true
  validate  :ne_peut_pas_etre_sans_village_existant
  
  def ne_peut_pas_etre_sans_village_existant
    errors.add(:village_id, "la photo n'appartient pas à un village existant") if !Village.find_by_id(self.village_id)
  end

  
  scope :actives_de_villages_actifs, joins(:village).where("photos.actif = ? and villages.actif = ?", true, true )
  scope :non_actives_de_villages_actifs, joins(:village).where("photos.actif = ? and villages.actif = ?", false, true )
  scope :actives, where("actif = ?", true)
  scope :non_actives, where("actif = ?", false)
  
  def prefix
    nom_court_village = self.village.nc ? self.village.nc : ""
    "#{nom_court_village}_#{id.to_s.rjust(5,'0')}"
  end
  
  def active_bascule_et_enregistre
    self.actif = !actif
    self.save
  end
  
    
end


# == Schema Information
#
# Table name: photos
#
#  id            :integer(4)      not null, primary key
#  village_id    :integer(4)
#  legende       :string(255)
#  info          :string(255)
#  url_originale :string(255)
#  actif         :boolean(1)      default(TRUE)
#  created_at    :datetime
#  updated_at    :datetime
#

