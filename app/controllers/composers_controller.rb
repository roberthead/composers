class ComposersController < ApplicationController
  def index
    composers = Composer.order(:birth_year).where.not(birth_year: nil).where.not(death_year: nil)
    birth_years = composers.pluck(:birth_year)
    earliest_birth_year = birth_years.min
    latest_birth_year = birth_years.max
    render json: { composers: composers, earliest_birth_year: earliest_birth_year, latest_birth_year: latest_birth_year }
  end
end
