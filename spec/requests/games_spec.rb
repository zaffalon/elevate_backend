require 'swagger_helper'

RSpec.describe 'games', type: :request do
  let!(:'Content-Type') { 'application/json' }
  let!(:user) { User.make! }
  let!(:api_key) { "Bearer #{Session.make!(user: user).token}" }
  let!(:Authorization) { api_key }

  path '/api/games' do
    get 'list games' do
      tags 'Games'
      let!(:game) { Game.make! }

      security [JWT: []]
      parameter name: 'Content-Type', default: 'application/json', in: :header, required: true

      response '200', 'Games returned successfully' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['games']).to include(hash_including('id' => game.id))
          expect(data['games'].count).to eq(1)
        end
      end
    end
  end
end
