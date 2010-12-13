# -*- encoding : utf-8 -*-
class Photo < ActiveRecord::Base
  belongs_to :village
  
  validates_presence_of :village_id
  validates :url_originale, :presence => true
  validate  :ne_peut_pas_etre_sans_village_existant, :teste_fichier_url_originale
  
  after_destroy :deplace_poubelle_fichiers_photos
  
  def ne_peut_pas_etre_sans_village_existant
    errors.add(:village_id, "la photo n'appartient pas à un village existant") if !Village.find_by_id(self.village_id)
  end
  
  def teste_fichier_url_originale
    if Rails.env.development? || Rails.env.production?
      #errors.add(:nc, "erreur1 à tester") if ne_passe_pas_le_test1
      #errors.add(:nc, "erreur2 à tester") if ne_passe_aps_le_test2
    end
  end

  
  scope :actives_de_villages_actifs, joins(:village).where("photos.actif = ? and villages.actif = ?", true, true ).order("villages.nc, photos.id")
  scope :non_actives_de_villages_actifs, joins(:village).where("photos.actif = ? and villages.actif = ?", false, true ).order("villages.nc, photos.id")
  scope :actives, joins(:village).where("photos.actif = ?", true).order("villages.nc, photos.id")
  scope :non_actives, joins(:village).where("photos.actif = ?", false).order("villages.nc, photos.id")
  
  
  def sauve_enregistrement_photo_et_cree_fichiers
    if self.save
      cree_fichier_photo(:ori)
      cree_fichier_photo(:def) unless url_definitive.blank?
    end
    return errors.empty?
  end
  
  def update_enregistrement_photo_et_update_fichiers(params, ecrase_fichier)
    if self.update_attributes(params[:photo])
      [:ori, :def].each {|type| cree_fichier_photo(type) if ecrase_fichier[type]}
    end
    return errors.empty?
  end
  
  def deplace_poubelle_fichiers_photos
    FIC_EXT.keys.each {|type| FileUtils.mv(fichier_photo(type), DIR_SUPPR) if File.file?(fichier_photo(type))}
  end
  
  def prefix
    "#{village.nc}_#{id.to_s.rjust(5,'0')}"
  end

  def active_bascule_et_enregistre
    self.actif = !actif
    active_bascule_fichiers_photos
    self.save
  end
  
  def active_bascule_fichiers_photos
    FIC_EXT.keys.each do |type_photo|
      FileUtils.mv fichier_photo(type_photo, !actif), fichier_photo(type_photo) if File.file?(fichier_photo(type_photo, !actif))
    end
  end
  
  def fichier_photo(type_photo, photo_active = self.actif)
    "#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI + "/" if !village.actif}#{village.dir_nom}/#{DIR_PHOTOS}/#{DIR_PHOTOS_DESACTI + "/" if !photo_active}#{DIR_TYPE_PHOTO[type_photo]}/#{prefix}#{FIC_EXT[type_photo]}.jpg"
  end
  
  def url_photo(type_photo)
    "#{URL_VILLAGES}/#{DIR_VILLAGES_DESACTI + "/" if !village.actif}#{village.dir_nom}/#{DIR_PHOTOS}/#{DIR_PHOTOS_DESACTI + "/" if !actif}#{DIR_TYPE_PHOTO[type_photo]}/#{prefix}#{FIC_EXT[type_photo]}.jpg"
  end
  
  def fichier_photo_existe?(type_photo)
    File.file?(fichier_photo(type_photo))
  end
  
  def fabrique_fichier_photo(depuis_type_photo, vers_type_photo)
    
    image = Magick::Image::read(fichier_photo(depuis_type_photo)).first
    
    image.change_geometry!(LARGEUR[vers_type_photo]) { |cols, rows, img| img.resize!(cols, rows)}
    image.write fichier_photo(vers_type_photo)
    
  end
  
  def cree_fichier_photo(type_photo)
    
    if type_photo == :ori
      tmp_nom_original = Rails.env.test? ? url_originale : url_originale.original_filename
      FileUtils.mv url_originale, fichier_photo(:ori)
      self.url_originale = tmp_nom_original
    elsif type_photo == :def
      tmp_nom_definitive = Rails.env.test? ? url_definitive : url_definitive.original_filename
      FileUtils.mv url_definitive, fichier_photo(:def)
      self.url_definitive = tmp_nom_definitive
    end
    
    self.save
    
    fabrique_fichier_photo(type_photo, :vig)
    fabrique_fichier_photo(type_photo, :web)
    
  end

end



# == Schema Information
#
# Table name: photos
#
#  id             :integer(4)      not null, primary key
#  village_id     :integer(4)
#  legende        :string(255)
#  info           :string(255)
#  url_originale  :string(255)
#  actif          :boolean(1)      default(TRUE)
#  created_at     :datetime
#  updated_at     :datetime
#  url_definitive :string(255)
#

