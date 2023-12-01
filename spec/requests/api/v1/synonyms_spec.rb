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
end
