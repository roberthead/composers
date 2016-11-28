class ComposersController < ApplicationController
  def index
    composers = Composer.order(:birth_year).where.not(birth_year: nil).where.not(death_year: nil)
    earliest_year = composers.pluck(:birth_year).min
    render json: { composers: composers, earliest_year: earliest_year }
  end
end
