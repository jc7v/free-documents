class DocumentController < ApplicationController

  before_action :find_document, only: [:show]

  def index
    @documents = Document
                     .order_by(params[:order_by])
                     .include_blobs
                     .includes(:tags)
                     .filter_by_tags(params[:tag_ids])
                     .accepted
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
    @document.hits += 1
    @document.save
    redirect_to rails_blob_path(@document.doc_asset, dispositon: :attachment) # TODO: open new tab
  end

  def search
    redirect_to root_path if params[:q].blank?
    @documents = Document.search(include: {doc_asset_attachment: :blob}) do
      fulltext params[:q], highlight: true
      with(:accepted, true)
      if (page = params[:page]) and page.respond_to?(:to_i)
        paginate(page: page.to_i, per_page: 15)
      end
    end
  end

  private

  def find_document
    @document = Document.find(params[:id])
  end
end
