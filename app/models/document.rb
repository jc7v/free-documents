class Document < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :user
  has_one_attached :doc_asset
  enum status: [:refused, :accepted]

  validates_presence_of :title, :doc_asset
  #TODO add default to 0
  validates :number_of_pages, numericality: {greater_than_or_equal_to: 0}
  validates :author, length: {maximum: 50}
  validate :realized_at_before_today

  private

  def realized_at_before_today
    return if realized_at.blank?

    if realized_at > Date.today
      errors.add(:realized_at, I18n.t('documents.errors.realized_at'))
    end
  end

end
