module ApplicationHelper
  def bootstrap_alert(type)
    {error: 'danger', alert: 'warning', notice: 'info'}[type.to_sym] || 'success'
  end

  def preview_document(asset)
    return asset if asset.image?
    return asset_url('pdf.png') if asset.blob.content_type == 'application/pdf'
    asset_url('unknow.png')
  end

  def prev_next_pagination(collection)
    unless collection.first_page? and collection.last_page?
      render('shared/prev_next_pagination', collection: collection, total_pages: collection.total_pages) if collection.any?
    end
  end
end
