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
  
  def nom_fichier_photo_originale
    "#{ELEMENTS_DIR}/#{village.dir_nom}#{PHOTOS_ORIGINALES_DIR}/#{prefix}_originale.jpg"
  end

  def nom_fichier_photo_definitive
    "#{ELEMENTS_DIR}/#{village.dir_nom}#{PHOTOS_DEFINITIVES_DIR}/#{prefix}_def.jpg"
  end

  def nom_fichier_photo_vignette
    "#{ELEMENTS_DIR}/#{village.dir_nom}#{PHOTOS_VIGNETTES_DIR}/#{prefix}_vignette.jpg"
  end

  def fichier_photo_definitive_existe?
    File.file?(nom_fichier_photo_definitive)
  end
  
  def cree_fichier_photo_originale
    #crée le fichier de photo originale selon la convention de nomage des photos et sauve le nom de la photo original pour mémoire
    tmp_nom_original = Rails.env.test? ? url_originale : url_originale.original_filename
    FileUtils.mv url_originale, nom_fichier_photo_originale
    self.url_originale = tmp_nom_original
    save
  end

  def cree_fichier_photo_definitive
    
    #crée le fichier de photo définitive selon la convention de nomage des photos et sauve le nom de la photo définitive pour mémoire
    tmp_nom_definitive = Rails.env.test? ? url_definitive : url_definitive.original_filename
    FileUtils.mv url_definitive, nom_fichier_photo_definitive
    self.url_definitive = tmp_nom_definitive
    save
    
    cree_fichier_photo_vignette
    
  end
  
  def cree_fichier_photo_vignette
    image_definitive = Magick::Image::read(nom_fichier_photo_definitive).first
    
    image_definitive.change_geometry!('100') { |cols, rows, img| img.resize!(cols, rows)}
    image_definitive.write nom_fichier_photo_vignette
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

