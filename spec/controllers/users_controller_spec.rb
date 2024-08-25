require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'renders the index template successfully' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #upload' do
    let(:valid_file) { fixture_file_upload('valid_users.csv', 'text/csv') }
    let(:invalid_file) { fixture_file_upload('invalid_users.csv', 'text/csv') }

    context 'with a valid CSV file' do
      it 'returns a successful JSON response with results' do
        post :upload, params: { file: valid_file }

        expect(response).to be_successful
        expect(response.content_type).to match(/json/)

        json_response = JSON.parse(response.body)
        expect(json_response['results']).to be_an(Array)
        expect(json_response['results']).not_to be_empty
      end
    end

    context 'with an invalid CSV file' do
      it 'returns a JSON response with errors' do
        password_error_empty_name = "Name can't be blank"
        password_error_empty_pass = "Password can't be blank"
        password_error_lenght = "Password must be between 10-16 characters, include at least one lowercase letter, one uppercase letter, and one digit"
        password_error_repeated_characters = "Password cannot contain three repeating characters in a row"

        post :upload, params: { file: invalid_file }

        expect(response).to be_successful
        expect(response.content_type).to match(/json/)

        json_response = JSON.parse(response.body)
        expect(json_response['results']).to be_an(Array)
        expect(json_response['results'].first["result"]).to eq("Error: #{password_error_empty_name}, #{password_error_lenght}")
        expect(json_response['results'].second["result"]).to eq("Error: #{password_error_lenght}")
        expect(json_response['results'].third["result"]).to eq("Error: #{password_error_repeated_characters}")
        expect(json_response['results'].last["result"]).to eq("Error: #{password_error_empty_pass}")
      end
    end

    context 'without a file' do
      it 'returns an empty array' do
        post :upload

        expect(response).to be_successful
        expect(response.content_type).to match(/json/)

        json_response = JSON.parse(response.body)
        expect(json_response['results']).to be_an(Array)
        expect(json_response['results']).to be_empty
      end
    end
  end
end
