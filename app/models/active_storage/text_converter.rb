module ActiveStorage

  ##
  # Convert to full text a pdf of a blob
  class TextConverter

    include ActiveStorage::Downloading

    attr_reader :blob

    def initialize(blob)
      @blob = blob
    end

    def to_s
      return '' unless blob.content_type == 'application/pdf'
      download_blob_to_tempfile do |file|
        PDF::Reader.new(file).pages.map do |p|
          p.text
        end.join("\n")
      end
    end
  end
end