class LinksController < ApplicationController
  def new
    @link = Link.new
  end

  def create
    @link = Links::Builder.find_or_create(link_params)
    if @link.valid?
      redirect_to @link
    else
      render 'new'
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def forward
    @link = Link.find_by(short_url: params[:short_url])
    redirect_to @link.long_url
  end

  private

  def link_params
    params.require(:link).permit(:long_url, :short_url)
  end
end
