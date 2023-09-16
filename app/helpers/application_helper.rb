module ApplicationHelper

  ##
  # Display a an alert using bootstrap
  def bootstrap_alert(type)
    {error: 'danger', alert: 'warning', notice: 'info'}[type.to_sym] || 'success'
  end

  ##
  # return an image as a prview of the document.
  # If no preview are available, return an unkonw logo
  def preview_document(asset)
    return asset_url('unknow.png') if asset.attachment.nil?
    return asset.variant(resize: '450x300') if asset.variable?
    return asset if asset.image?
    return asset.preview(resize: '300x200') if asset.previewable?
   # return asset_url('pdf.png') if asset.blob.content_type == 'application/pdf'
    asset_url('unknow.png')
  end

  ##
  # Display a basic pagination with bootstrap
  def prev_next_pagination(collection)
    unless collection.first_page? and collection.last_page?
      render('shared/prev_next_pagination', collection: collection, total_pages: collection.total_pages) if collection.length > 0
    end
  end

  ##
  # return true if the param order_by passed in the url match tha actual value of the html select
  # By default, return true for the option *:updated_at_desc*
  # i.e make the option 'latest' is chosen by default
  def sort_selected?(value)
    order_by = params[:order_by]
    (order_by.nil? and value == :updated_at_desc) or (order_by.respond_to?(:to_sym) and value == order_by.to_sym)
  end

  ##
  # return true if the *tag* is included is the array of tags passed by the param *tag_ids* of hte url
  def tag_selected?(tag)
    (params[:tag_ids].respond_to?(:include?) and params[:tag_ids].include?(tag.id.to_s))
  end

  ##
  # Display all tags of a document to bootstrap badges
  def tags_to_badges(document)
    document = document.reload if params[:tag_ids]
    document.tags.map do |tag|
      link_to tag, root_path('tag_ids[]' => tag.id), class: 'badge badge-secondary'
    end.join(' ').html_safe
  end

  ##
  # print a link, symbolized by a download icon, to download the associated doc
  def document_download_icon(document)
    link_to '', document_download_path(document_id: document), class: 'glyphicon glyphicon-download'
  end

  ##
  # Print the highlighted word of the *what* field formatted with the corresponding html tag.
  # if no highlight for the *hit*, the field given by *what* is tried for *result*
  def highlight_solr(hit, result, what)
    hit.highlight(what).try(:format) {|word| "<tt class='bg-warning'>#{h(word)}</tt>"}.try(:html_safe) || result.try(what)
  end

  ##
  # display a link formatted as a button with a possible icon a the left of the text
  def btn_link(text, path, type: 'primary', icon: '', outline: false)
    i = ''
    btn_outline = ''
    btn_outline = '-outline' if outline
    i = "<i class='glyphicon glyphicon-#{icon}'></i>" unless icon.blank?
    "<a href='#{h(path)}' class='btn btn#{btn_outline}-#{type}'>#{i} #{h(text)}</a>".html_safe
  end

  ##
  # return true if *controller* == the name of the current controller and the current
  # action is any of the element in *with*
  # false otherwise
  def one_of_actions?(controller: '', actions: [])
    controller_name == controller and actions.any? { |action| action == action_name}
  end
end
