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

  scope :include_blobs, -> {
    # includes(doc_asset_attachment: :blob)
  }

  scope :accepted, -> {
    where(status: :accepted)
  }

  scope :find_by_tags, ->(ids) {

  }

  def self.order_by(choice=:updated_at_desc)
    choice = (choice || :updated_at_desc).to_sym
    choice = :updated_at_desc unless ordered_choices.has_key?(choice)
    order(ordered_choices[choice].first)
  end

  def self.ordered_choices
    @@order_by_choices ||= {
      updated_at_desc: [{updated_at: :desc}, I18n.t('documents.index.order_by.updated_at_desc')],
      updated_at_asc: [{updated_at: :asc}, I18n.t('documents.index.order_by.updated_at_asc')],
      title_desc: [{title: :desc}, I18n.t('documents.index.order_by.title_desc')],
      title_asc: [{title: :asc}, I18n.t('documents.index.order_by.title_asc')],
    }
  end

  searchable do
    text :title, :description
    text :doc_asset do
      PDFToText.new(self.doc_asset.blob).to_s if doc_asset.content_type == 'application/pdf'
    end
  end

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
