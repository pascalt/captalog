# -*- encoding : utf-8 -*-
URL_VILLAGES          = "/#{"test/" if Rails.env.test?}villages"
DIR_VILLAGES          = "#{Rails.root.to_s}/public#{URL_VILLAGES}"
DIR_SUPPR             = "#{Rails.root.to_s}/public/#{"test/" if Rails.env.test?}_suppr"
FIC_EXT               = {:ori => '_ori', :def => '_def', :vig => '_vig', :web => '_web'}
DIR_PHOTOS            = 'photos'
DIR_TYPE_PHOTO        = {:ori => 'originale', :def => 'def', :vig => 'vignette', :web => 'web'}
DIR_PHOTOS_DESACTI    = '_desactivees'
DIR_VILLAGES_DESACTI  = '_desactives'
DIR_CARTES            = 'cartes'
DIR_TYPE_CARTE        = {:ori => 'carte', :vig => 'vignette', :web => 'web'}
DIR_CARTES_DESACTI    = '_desactivees'
FIC_EXT_CARTE         = {:ori => '_ori', :vig => '_vig', :web => '_web'}
DIR_SUPPR_CARTE       = "#{Rails.root.to_s}/public/#{"test/" if Rails.env.test?}_suppr_carte"
LARGEUR               = {:vig => '100', :web => '320'}
EXTENTION             = {:ori => '.pdf', :vig => '.jpg', :web => '.jpg'}
