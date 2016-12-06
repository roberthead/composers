class ComposerSource < ApplicationRecord
  belongs_to :composer
  belongs_to :source

  validates :composer, presence: true
  validates :source, presence: true

  after_save :recompute_composer_importance

  private

  def recompute_composer_importance
    composer.reload
    composer.update_attributes(importance: ImportanceEvaluation.new(composer).importance)
  end
end
