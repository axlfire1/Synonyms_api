require 'rails_helper'

RSpec.describe "Api::V1::Synonyms", type: :request do
  let(:base_url) { 'http://localhost:3000' }

  before(:all) do
    User.create!(username: 'admin', password: '$dm!nhola123', role: 'admin')
    Synonym.create!(word: 'cool', synonym: 'ok', approved: true)
  end

  context 'anonymous' do
    it 'gets the list of synonyms' do
      get "#{base_url}/api/v1/synonyms"
      expect(response).to be_successful

      expect(JSON.parse(response.body)).to eq([["cool", "ok"]])
    end

    it 'posts a new synonyms' do
      valid_params = {
        "synonym": {
            "word": "sick",
            "synonym": "cool"
          }
      }
    
      post "#{base_url}/api/v1/synonyms", params: valid_params, as: :json
      expect(response).to be_successful

      approved = JSON.parse(response.body)['approved']
      expect(approved).to eq(false) 
    end
  end

  context 'admin' do
    it 'logins correctly' do
      valid_params = {
        "username": "admin",
        "password": "$dm!nhola123"
      }
    
      post "#{base_url}/api/v1/login", params: valid_params, as: :json
      expect(response).to be_successful

      token = JSON.parse(response.body)['token']
      expect(token.size).to eq(99)
    end

    it 'updates synonym correctly' do
      synonym = Synonym.create!(word: 'othe', synonym: 'cool', approved: false)

      valid_params = {
        "username": "admin",
        "password": "$dm!nhola123"
      }
    
      post "#{base_url}/api/v1/login", params: valid_params, as: :json
      expect(response).to be_successful

      token = JSON.parse(response.body)['token']
      expect(token.size).to eq(99)

      expect(Synonym.count).to eq(2)
      expect(Synonym.find(synonym.id).approved).to eq(false)

      patch "#{base_url}/api/v1/admin/synonyms/#{synonym.id}", params: valid_params, as: :json, headers: { 'Authorization' => "Bearer #{token}" }
      
      expect(Synonym.find(synonym.id).approved).to eq(true)
    end

    it 'gets synonyms correctly' do
      valid_params = {
        "username": "admin",
        "password": "$dm!nhola123"
      }
    
      post "#{base_url}/api/v1/login", params: valid_params, as: :json
      expect(response).to be_successful

      token = JSON.parse(response.body)['token']
      expect(token.size).to eq(99)

      get "#{base_url}/api/v1/admin/synonyms", as: :json, headers: { 'Authorization' => "Bearer #{token}" }
      
      expect(JSON.parse(response.body).first['approved']).to eq(true)
    end

    it 'deletes synonym correctly' do
      valid_params = {
        "username": "admin",
        "password": "$dm!nhola123"
      }
    
      post "#{base_url}/api/v1/login", params: valid_params, as: :json
      expect(response).to be_successful

      token = JSON.parse(response.body)['token']
      expect(token.size).to eq(99)

      expect(Synonym.count).to eq(1)

      delete "#{base_url}/api/v1/admin/synonyms/#{Synonym.last.id}", as: :json, headers: { 'Authorization' => "Bearer #{token}" }
      
      expect(Synonym.count).to eq(0)
      expect(response.status).to eq(204)
    end
  end
end
