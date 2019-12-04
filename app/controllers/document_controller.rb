class DocumentController < ApplicationController

  before_action :find_document, only: [:show]
  before_action :authenticate_user!, only: [:edit, :create]

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
    redirect_to new_user_session_path, notice: 'You have to be logged in to upload a document' unless current_user

  end

  def create
    if params[:populated]
      @document = Document.new(params.require(:document).permit(:doc_asset, tag_ids: []))
      if @document.doc_asset_presence
        @document.populate_from_asset
        render 'edit'
      else
        render 'new'
      end
    else
      @document = Document.new(params.require(:document)
                        .permit(:title, :description, :number_of_pages, :author, :realized_at, :doc_asset, tag_ids: [])
      )
      @document.user = current_user
      if @document.save
        redirect_to root_path, notice: t('documents.created.notice')
      else
        render 'edit'
      end
    end
  end

  def edit

  end

  def show
  end

  ##
  # before someone download the document, we want to update the *hits* of a document
  # The number of times it is downloaded
  def download
    @document = Document.find(params[:document_id])
    @document.hits += 1
    @document.save(touch: false)
    redirect_to rails_blob_path(@document.doc_asset, dispositon: :attachment) # TODO: open new tab
  end

  ##
  # plain text search with solr
  # *params[:q]* the text to search for
  # *params[:page]* which page of the result to query. 18 items per page
  # TODO: filter by tags and ordering
  def search
    redirect_to root_path if params[:q].blank?
    @search = Document.search(include: {doc_asset_attachment: :blob}) do
      fulltext params[:q], highlight: true
      with(:accepted, true)
      if (page = params[:page].try(:to_i))
        paginate(page: page, per_page: 18)
      end
    end
  end

  private

  def find_document
    @document = Document.find(params[:id])
  end
end
