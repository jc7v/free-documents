class Document < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :user
  has_one_attached :doc_asset
  enum status: [:refused, :accepted]

  before_validation :set_number_of_pages_to_0

  validates_presence_of :title
  validates :number_of_pages, numericality: {greater_than_or_equal_to: 0}
  validates :author, length: {maximum: 50}
  validate :realized_at_before_today
  validate :doc_asset_presence

  private

  def realized_at_before_today
    return if realized_at.blank?

    if realized_at > Date.today
      errors.add(:realized_at, I18n.t('documents.errors.realized_at'))
    end
  end

  def doc_asset_presence
    errors.add(:doc_asset, I18n.t('documents.errors.doc_asset.presence')) unless self.doc_asset.attached?
  end

  def set_number_of_pages_to_0
    self.number_of_pages = 0 if number_of_pages.blank?
  end

end
