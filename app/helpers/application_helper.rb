module ApplicationHelper
  def bootstrap_alert(type)
    {error: 'danger', alert: 'warning', notice: 'info'}[type.to_sym] || 'success'
  end

  def preview_document(asset)
    return asset if asset.image?
    image_tag(asset_url('file.png'))
  end
end
