class ComposersController < ApplicationController
  def index
    composers = Composer.order(:birth_year).all
    render json: { composers: composers }
  end
end
