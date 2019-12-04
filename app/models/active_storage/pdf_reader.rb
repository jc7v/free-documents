module ActiveStorage

  ##
  # Convert to full text a pdf of a blob
  class PdfReader

    include ActiveStorage::Downloading

    attr_reader :blob

    def initialize(blob)
      @blob = blob
      @reader = nil
      if blob.content_type == 'application/pdf'
        download_blob_to_tempfile do |file|
          @reader = PDF::Reader.new(file)
          @reader.inspect
          @reader.pages
        end
      end
    end

    def pdf?
      blob.content_type == 'application/pdf'
    end

    def reader(&block)
     return nil unless pdf?
      download_blob_to_tempfile do |file|
        block.call(PDF::Reader.new(file))
      end
    end

    def to_s
      return '' if pdf?
      download_blob_to_tempfile do |file|
        PDF::Reader.new(file).pages.map do |p|
        p.text
        end.join("\n")
      end
    end
  end
end