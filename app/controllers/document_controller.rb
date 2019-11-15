class DocumentController < ApplicationController
  def index
    # TODO: include blob
    @documents = Document
                     .order(updated_at: :desc).page(params[:page])
                     .includes(doc_asset_attachment: :blob)
                     .where(status: :accepted)
                      .page(params[:page])
  end

  def show
    redirect_to root_path
  end

  def new
    @document = Document.new
  end

  def create
  end

  def update
  end

  def delete
  end

  private

end
