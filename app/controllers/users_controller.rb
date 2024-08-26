class UsersController < ApplicationController
  def index; end

  def upload
    results = CsvUploaderService.new(params[:file]).process
    render json: { results: results }
  end
end
