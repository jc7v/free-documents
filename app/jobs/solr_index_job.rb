class SolrIndexJob < ApplicationJob
  queue_as :default

  # TODO commit after 30s or x index called from jobs
  def perform(document)
    document.index
    Sunspot.commit(true)
    logger.info "Document #{document.title} should have been indexed to solr"
  end
end
