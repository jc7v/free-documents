module ApplicationHelper
  def bootstrap_alert(type)
    {error: 'danger', alert: 'warning', notice: 'info'}[type.to_sym] || 'success'
  end

  def preview_document(asset)
    return asset.variant(resize: '450x300') if asset.variable?
    return asset if asset.image?
    return asset_url('pdf.png') if asset.blob.content_type == 'application/pdf'
    asset_url('unknow.png')
  end

  def prev_next_pagination(collection)
    unless collection.first_page? and collection.last_page?
      render('shared/prev_next_pagination', collection: collection, total_pages: collection.total_pages) if collection.any?
    end
  end

  def sort_selected?(value)
    order_by = params[:order_by]
    (order_by.nil? and value == :updated_at_desc) or (order_by.respond_to?(:to_sym) and value == order_by.to_sym)
  end

  def tag_selected?(tag)
    (params[:tag_ids].respond_to?(:include?) and params[:tag_ids].include?(tag.id.to_s))
  end

  def tags_to_badges(document)
    document = document.reload if params[:tag_ids]
    document.tags.map do |tag|
      link_to tag, root_path('tag_ids[]' => tag.id), class: 'badge badge-secondary'
    end.join(' ').html_safe
  end

  def document_download_icon(document)
    link_to '', document_download_path(document_id: document), class: 'glyphicon glyphicon-download'
  end
end
