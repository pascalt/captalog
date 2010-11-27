# -*- encoding : utf-8 -*-
module VillagesHelper
  
  def nom_avec_article_entre_parenthese(village)
    village.article.blank? ? village.nom_sa : village.nom_sa + " (" + village.article + ")"
     
  end
  
  def nc_ayant_un_repertoire(village)
    "[#{village.nc}]"
  end
  
end
