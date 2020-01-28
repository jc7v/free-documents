class SolrIndexJob < ApplicationJob
  queue_as :default

  def perform(document)
    document.index
    Sunspot.commit
    logger.warn "Document #{document.title} should have been indexed to solr"
  end
end
