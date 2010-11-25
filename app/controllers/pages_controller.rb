# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  def menu
    @titre = "Menu"
  end
  def admin
    @titre = "Administration"
  end
end
