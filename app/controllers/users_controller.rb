class UsersController < ApplicationController
  def index; end

  def upload
    @results = []

    if params[:file].present?
      CSV.foreach(params[:file].path, headers: true) do |row|
        user = User.new(name: row['name'], password: row['password'])
        if user.save
          @results << { name: row['name'], result: 'Success' }
        else
          @results << { name: row['name'], result: "Error: #{user.errors.full_messages.join(', ')}" }
        end
      end
    else
      @results << { error: "No file uploaded" }
    end

    render :index
  end
end
