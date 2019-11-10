class DocumentController < ApplicationController
  def index
    @documents = Document.order(updated_at: :desc).page(params[:page])
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
