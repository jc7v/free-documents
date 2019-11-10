class Document < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :doc_asset
  validates :number_of_pages, numericality: {greater_than_or_equal_to: 0}
  validates :author, length: {maximum: 50}
  validate :realized_at_before_today

  private

  def realized_at_before_today
    return if realized_at.blank?

    if realized_at > Date.today
      errors.add(:realized_at, t('documents.errors.realized_at'))
    end
  end

end
