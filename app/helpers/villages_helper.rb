# -*- encoding : utf-8 -*-
module VillagesHelper
  def nom_art_parenth(village)
    village.article.blank? ? village.nom_sa : village.nom_sa + " (" + village.article + ")"
  end
  
end
