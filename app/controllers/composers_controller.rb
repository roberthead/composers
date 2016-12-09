class ComposersController < ApplicationController
  def index
    composers = Composer.where.not(birth_year: nil).where.not(death_year: nil).order(importance: :desc).limit(200)
    birth_years = composers.pluck(:birth_year)
    death_years = composers.pluck(:death_year)
    render json: {
      composers: composers.sort_by(&:birth_year),
      earliest_birth_year: birth_years.min,
      latest_birth_year: birth_years.max,
      earliest_death_year: death_years.min,
      latest_death_year: death_years.max,
    }
  end
end
