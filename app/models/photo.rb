# -*- encoding : utf-8 -*-
class Photo < ActiveRecord::Base
  belongs_to :village
  
  validates_presence_of :village_id
  validates :url_originale, :presence => true, :uniqueness => true
  validate  :ne_peut_pas_etre_sans_village_existant
  
  def ne_peut_pas_etre_sans_village_existant
    errors.add(:village_id, "la photo n'appartient pas à un village inexistant") if !Village.find_by_id(self.village_id)
  end

  
  scope :toutes_actives, where("actif = ?", true)
  
  def prefix
    nom_court_village = self.village.nc ? self.village.nc : ""
    "#{nom_court_village}_#{id.to_s.rjust(5,'0')}"
  end
  
end

# == Schema Information
#
# Table name: photos
#
#  id            :integer(4)      not null, primary key
#  village_id    :integer(4)
#  nom           :string(255)
#  legende       :string(255)
#  info          :string(255)
#  url_originale :string(255)
#  actif         :boolean(1)
#  created_at    :datetime
#  updated_at    :datetime
#

