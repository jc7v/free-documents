class Document < ApplicationRecord

  has_and_belongs_to_many :tags
  belongs_to :user
  has_one_attached :doc_asset
  enum status: [:refused, :accepted]

  before_validation :set_number_of_pages_to_0
  after_save :set_file_name

  validates_presence_of :title
  validates :number_of_pages, numericality: {greater_than_or_equal_to: 0}
  validates :author, length: {maximum: 50}
  validate :realized_in_past
  validate :doc_asset_presence

  scope :include_blobs, -> {
     includes(doc_asset_attachment: :blob)
  }

  ##
  # Find all documents associated to any of the given tags
  # *ids* is an array of ids corresponding to the tags to search for
  # Actually, it find all the documents associated at least with one of the tags
  # To find all the documents associated with all the given tags:
  #     having('COUNT(DISTINCT tags.id) = :having', having: ids.size)
  scope :filter_by_tags, ->(ids) {
    if ids.respond_to?(:any?) and ids.any?
      joins(:tags)
          .where(tags: {id: ids})
          .group(:id)
    end
  }

  ##
  # Order the documents from the user input choice.
  # If the user choice is not a choice included in *ordered_choices*
  # The default value *updated_at_desc* is used
  def self.order_by(choice=:updated_at_desc)
    choice = (choice || :updated_at_desc).to_sym
    choice = :updated_at_desc unless ordered_choices.has_key?(choice)
    order(ordered_choices[choice])
  end

  ##
  # return a *Hash* with the possible ways to order the collection Document for a user.
  # the keys of the *Hash* is the possible choices for the user and the values, a *Hash*
  # passed to the method *order()* of *Document*
  def self.ordered_choices
    ORDERED_CHOICES
  end

  ##
  # For SolR indexing
  searchable auto_index: false do
    text :title, stored: true
    text :description, stored: true
    text :doc_asset, stored: true do
      ActiveStorage::PdfReader.new(doc_asset.blob).to_s if pdf?
    end
    boolean(:accepted) { status == 'accepted' }
  end

  ##
  # TODO: it would be nicer is the class *ActiveSupport::Blob* like *image?* or *video?*
  def pdf?
    doc_asset.content_type == 'application/pdf'
  end

  ##
  # Start a job for indexing to SolR
  def index_to_solr
    SolrIndexJob.perform_later(self)
  end

  ##
  # Check if a file is uploaded
  def doc_asset_presence
    unless self.doc_asset.attached?
      errors.add(:doc_asset, I18n.t('documents.errors.doc_asset.presence'))
      return false
    end
    true
  end

  ##
  # Try to extract as much content from the uploaded file
  def populate_from_asset
    if pdf?
      begin
          ActiveStorage::PdfReader.new(doc_asset.blob).reader do |reader|
            self.title = convert_to_utf_8(reader.info[:Title] || doc_asset.blob.filename)
            self.description = convert_to_utf_8(reader.pages.first.text[0..500].gsub(/\s{2,}/, ''))
            self.author = convert_to_utf_8(reader.info[:Author])
            unless (pdf_date = reader.info[:CreationDate]).blank?
              date = Date.strptime(pdf_date, 'D:%Y%m%d')
              self.realized_at = date if date < Date.today
            end
            self.number_of_pages = reader.pages.size
          end
      rescue PDF::Reader::MalformedPDFError
        self.title = doc_asset.blob.filename
      end
    else
      self.title = doc_asset.blob.filename
    end
    self.title = I18n.t('documents.model.unknown_title') if self.title.empty?
  end

  ##
  # Search if it exists similar documents
  # Actually only based on the title
  def similar_documents
    Document.search do
      fulltext self.title
    end
  end

  private

  ##
  # After each save, set the value of *title* to the name of the attached file
  def set_file_name
    doc_asset.blob.filename = title
    doc_asset.blob.save
  end

  ##
  # Determine the encoding of the *string* and from that init a Converter and convert the *string* to UTF-8
  def convert_to_utf_8(string)
    return if string.encoding == Encoding::UTF_8
    encoder = Encoding::Converter.new(string.encoding, Encoding::UTF_8, undef: :replace)
    encoder.convert(string)
  end

  ORDERED_CHOICES = {
      updated_at_desc: {updated_at: :desc},
      updated_at_asc: {updated_at: :asc},
      title_desc: {title: :desc},
      title_asc: {title: :asc}
  }

  def realized_in_past
    return nil if realized_at.blank?

    if realized_at > Date.today
      errors.add(:realized_at, I18n.t('documents.errors.realized_at'))
    end
  end

  def set_number_of_pages_to_0
    self.number_of_pages = 0 if number_of_pages.blank?
  end
end
