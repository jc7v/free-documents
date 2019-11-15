module ApplicationHelper
  def bootstrap_alert(type)
    {error: 'danger', alert: 'warning', notice: 'info'}[type.to_sym] || 'success'
  end

  def preview_document(asset)
    return asset if asset.image?
    return asset_url('pdf.png') if asset.blob.content_type == 'application/pdf'
    asset_url('unknow.png')
  end

  def prev_next_pagination(collection, record)
    paginate = Paginate.new(collection, record) # TODO: Paginate should return the same instance for the same collection
    render('shared/prev_next_pagination', collection: collection, total_pages: paginate.total_pages ) if paginate.has_multiple_pages?
  end
end
