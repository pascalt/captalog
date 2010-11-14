# -*- encoding : utf-8 -*-

# == Schema Information
#
# Table name: regions
#
#  id         :integer(4)      not null, primary key
#  nom        :string(255)
#  code       :string(255)
#  nc         :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Region < ActiveRecord::Base
  has_many :departements
end
