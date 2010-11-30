# -*- encoding : utf-8 -*-
class Photo < ActiveRecord::Base
  belongs_to :village
  
  validates_presence_of :village_id
  validates :url_originale, :presence => true
  validate  :ne_peut_pas_etre_sans_village_existant, :teste_fichier_url_originale
  
  def ne_peut_pas_etre_sans_village_existant
    errors.add(:village_id, "la photo n'appartient pas à un village existant") if !Village.find_by_id(self.village_id)
  end
  
  def teste_fichier_url_originale
    if Rails.env.development? || Rails.env.production?
      #errors.add(:nc, "erreur1 à tester") if ne_passe_pas_le_test1
      #errors.add(:nc, "erreur2 à tester") if ne_passe_aps_le_test2
    end
  end

  
  scope :actives_de_villages_actifs, joins(:village).where("photos.actif = ? and villages.actif = ?", true, true )
  scope :non_actives_de_villages_actifs, joins(:village).where("photos.actif = ? and villages.actif = ?", false, true )
  scope :actives, where("actif = ?", true)
  scope :non_actives, where("actif = ?", false)
  
  def prefix
    "#{village.nc}_#{id.to_s.rjust(5,'0')}"
  end

  def active_bascule_et_enregistre
    self.actif = !actif
    self.save
  end
  
  def cree_fichiers_photos
    #crée le fichier de photo originale selon la convention de nomage des photos et sauve le nom de la photo original pour mémoire
    tmp_nom_original = Rails.env.test? ? url_originale : url_originale.original_filename
    FileUtils.mv url_originale, "#{ELEMENTS_DIR}/#{village.dir_nom}#{PHOTOS_ORIGINALES_DIR}/#{prefix}_originale.jpg"
    self.url_originale = tmp_nom_original
    save
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

