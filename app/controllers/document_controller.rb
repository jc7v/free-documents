class DocumentController < ApplicationController

  before_action :find_document, only: [:show]

  def index
    where_ids = ''
    tag_ids = params[:tag_ids]
    join_tags = ''
    if tag_ids.respond_to?(:any?) and tag_ids.any?
      where_ids = tag_ids.map { |id| 'tags.id=?' unless id.blank? }.join(' AND ')
      join_tags = :tags unless where_ids.blank?
    end
    @documents = Document
      .order_by(params[:order_by])
      .includes(doc_asset_attachment: :blob)
      .includes(:tags)
      .joins(join_tags)
      .where(status: :accepted)
      .where(where_ids, *tag_ids)
      .page(params[:page])
  end

  def new
    @document = Document.new
    redirect_to root_path, notice: 'You have to be logged in to upload a document' unless current_user
  end

  def create
    @document = Document.new(params.require(:document).permit(:title, :description))
  end

  def show
  end

  def download
    @document = Document.find(params[:document_id])
    @document.hits+=1
    @document.save
    redirect_to rails_blob_path(@document.doc_asset, dispositon: :attachment) # TODO: open new tab
  end

  private

  def find_document
    @document = Document.find(params[:id])
  end
end
