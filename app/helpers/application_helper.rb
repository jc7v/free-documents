module ApplicationHelper
  def bootstrap_alert(type)
    {error: 'danger', alert: 'warning', notice: 'info'}[type.to_sym] || 'success'
  end
end
