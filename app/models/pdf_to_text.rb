class PDFToText
  include ActiveStorage::Downloading

  attr_reader :blob

  def initialize(blob)
    @blob = blob
  end

  def to_s
    return nil unless blob.content_type == 'application/pdf'
    download_blob_to_tempfile do |file|
      PDF::Reader.new(file).pages.map do |p|
        p.text
      end.join("\n")
    end
  end
end