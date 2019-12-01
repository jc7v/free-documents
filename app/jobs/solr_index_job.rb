class SolrIndexJob < ApplicationJob
  queue_as :default

  def perform(document)
    document.index
  end
end
