class DocumentController < ApplicationController

  before_action :find_document, only: [ :show ]

  def index
    @order_by_choices = {
        updated_at_desc: [{updated_at: :desc}, t('documents.index.order_by.updated_at_desc')],
        updated_at_asc: [{updated_at: :asc}, t('documents.index.order_by.updated_at_asc')],
        title_desc: [{title: :desc}, t('documents.index.order_by.title_desc')],
        title_asc: [{title: :asc}, t('documents.index.order_by.title_asc')],
    }
    order_by = (params[:order_by] || :updated_at_desc).to_sym
    @documents = Document
                     .order(@order_by_choices[order_by].first)
                     .includes(doc_asset_attachment: :blob)
                     .where(status: :accepted)
                      .page(params[:page])
  end

  def show
  end

  def download
    @document = Document.find(params[:document_id])
    @document.hits+=1
    @document.save
    redirect_to rails_blob_path(@document.doc_asset, dispositon: 'attachment') # TODO: open new tab
  end

  private

  def find_document
    @document = Document.find(params[:id])
  end
end
