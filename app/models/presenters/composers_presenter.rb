class ComposersPresenter
  def composers
    @composers ||= Composer.where.not(birth_year: nil).where.not(death_year: nil).map { |composer| ComposerView.new(composer) }
  end

  def earliest_birth_year
    birth_years.min
  end

  def latest_birth_year
    birth_years.max
  end

  private

  def birth_years
    birth_years = composers.pluck(:birth_year)
  end

end
