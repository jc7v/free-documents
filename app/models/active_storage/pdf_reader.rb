module ActiveStorage

  ##
  # Convert to full text a pdf of a blob
  class PdfReader

    include ActiveStorage::Downloading

    attr_reader :blob

    def initialize(blob)
      @blob = blob
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
        begin
            PDF::Reader.new(file).pages.map do |p|
                p.text
            end.join("\n")
        rescue
            ''
        end
      end
    end
  end
end
