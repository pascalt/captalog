# -*- encoding : utf-8 -*-
class Carte < ActiveRecord::Base
  
  belongs_to :village
  
  validates_presence_of :village_id
  validates :url_originale, :presence => true
  validate  :ne_peut_pas_etre_sans_village_existant
  
  after_destroy :deplace_poubelle_fichiers_cartes
  
  def ne_peut_pas_etre_sans_village_existant
    errors.add(:village_id, "la carte n'appartient pas à un village existant") if !Village.find_by_id(self.village_id)
  end
  
  
  scope :actives_de_villages_actifs, joins(:village).where("cartes.actif = ? and villages.actif = ?", true, true ).order("villages.nc, cartes.id")
  scope :non_actives_de_villages_actifs, joins(:village).where("cartes.actif = ? and villages.actif = ?", false, true ).order("villages.nc, cartes.id")
  scope :actives, joins(:village).where("cartes.actif = ?", true).order("villages.nc, cartes.id")
  scope :non_actives, joins(:village).where("cartes.actif = ?", false).order("villages.nc, cartes.id")
  
  def sauve_enregistrement_carte_et_cree_fichiers
    if self.save
      cree_fichier_carte
    end
    return errors.empty?
  end
  
  def update_enregistrement_carte_et_update_fichiers(params, ecrase_fichier)
    if self.update_attributes(params[:carte])
      cree_fichier_carte if ecrase_fichier
    end
    return errors.empty?
  end
  
  def deplace_poubelle_fichiers_cartes
    FIC_EXT_CARTE.keys.each {|type| FileUtils.mv(fichier_carte(type), DIR_SUPPR_CARTE) if File.file?(fichier_carte(type))}
  end
  
  def prefix
    "#{village.nc}_#{id.to_s.rjust(5,'0')}"
  end
  
  def active_bascule_et_enregistre
    self.actif = !actif
    active_bascule_fichiers_cartes
    self.save
  end
  
  def active_bascule_fichiers_cartes
    FIC_EXT_CARTE.keys.each do |type_carte|
      FileUtils.mv fichier_carte(type_carte, !actif), fichier_carte(type_carte) if File.file?(fichier_carte(type_carte, !actif))
    end
  end
  

  def fichier_carte(type_carte, carte_active = self.actif)
    "#{DIR_VILLAGES}/#{DIR_VILLAGES_DESACTI + "/" if !village.actif}#{village.dir_nom}/#{DIR_CARTES}/#{DIR_CARTES_DESACTI + "/" if !carte_active}#{DIR_TYPE_CARTE[type_carte]}/#{prefix}#{FIC_EXT[type_carte]}#{EXTENTION[type_carte]}"
  end
  
  def url_carte(type_carte)
    "#{URL_VILLAGES}/#{DIR_VILLAGES_DESACTI + "/" if !village.actif}#{village.dir_nom}/#{DIR_CARTES}/#{DIR_CARTES_DESACTI + "/" if !actif}#{DIR_TYPE_CARTE[type_carte]}/#{prefix}#{FIC_EXT[type_carte]}#{EXTENTION[type_carte]}"
  end
  
  def fichier_carte_existe?(type_carte)
    File.file?(fichier_carte(type_carte))
  end
  
  def fabrique_fichier_carte(vers_type_carte)
    
    # image = Magick::Image::read(fichier_carte(:ori)).first
    # 
    # image.change_geometry!(LARGEUR[vers_type_carte]) { |cols, rows, img| img.resize!(cols, rows)}
    # image.write fichier_carte(vers_type_carte)

    image = Magick::Image::read(fichier_carte(:ori))
     if image[0].colorspace == Magick::CMYKColorspace
        image[0].colorspace = Magick::RGBColorspace
        image[0] =  image[0].negate
     end    
    
    image[0].change_geometry!(LARGEUR[vers_type_carte]) { |cols, rows, img| img.resize!(cols, rows)}
    image[0].write fichier_carte(vers_type_carte) { self.density = "300x300", self.quality = 100 }

    
  end
  
  def cree_fichier_carte
    
    tmp_nom_original = Rails.env.test? ? url_originale : url_originale.original_filename
    nom_original = Rails.env.test? ? url_originale : url_originale.path
       
    FileUtils.mv nom_original, fichier_carte(:ori)
    self.url_originale = tmp_nom_original
    
    self.save
    
    fabrique_fichier_carte(:vig)
    fabrique_fichier_carte(:web)
    
  end


end


# == Schema Information
#
# Table name: cartes
#
#  id            :integer(4)      not null, primary key
#  nom           :string(255)
#  info          :string(255)
#  village_id    :integer(4)
#  url_originale :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  actif         :boolean(1)      default(TRUE)
#

