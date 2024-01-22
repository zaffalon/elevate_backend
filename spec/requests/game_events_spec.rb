require 'swagger_helper'

RSpec.describe 'game events', type: :request do
  let!(:'Content-Type') { 'application/json' }
  let!(:user) { User.make! }
  let!(:api_key) { "Bearer #{Session.make!(user: user).token}" }
  let!(:Authorization) { api_key }
  let!(:game) { Game.make! }

  path '/api/user/game_events' do
    post 'create game event' do
      tags 'Game Events'
      security [JWT: []]
      parameter name: 'Content-Type', default: 'application/json', in: :header, required: true

      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          game_event: {
            type: :object,
            properties: {
              type: { type: :string, example: 'COMPLETED', required: true },
              occurred_at: { type: :string, example: '2021-10-01 20:00:00', required: true },
              game_id: { type: :string, example: "c69f13bb-5540-48c2-9e02-d90a0026e4b2", required: true }
            },
            required: true
          }
        }
      }

      let(:request_body) {
        { type: 'COMPLETED', occurred_at: '2021-10-01 20:00:00', game_id: game.id }
      }

      response '201', 'Created' do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to include('game_event' => hash_including('type' => 'COMPLETED', 'game_id' => game.id, 'user_id' => user.id))
          expect(data['game_event']["occurred_at"].to_datetime.to_i).to eq(request_body.dig(:occurred_at).to_datetime.to_i)
        end
      end

      response '422', 'Unprocessable Entity' do
        let(:request_body) { { type: 'COMPLETED', occurred_at: '2021-10-01 20:00:00' } } # Missing game_id
        run_test!
      end
    end
  end
end
