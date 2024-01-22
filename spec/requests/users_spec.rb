require "swagger_helper"

RSpec.describe "users", type: :request do
  let(:'Content-Type') { "application/json" }

  path "/api/user" do
    post "create user" do
      tags "Users"
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true

      parameter name: :request_body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: {
                type: :string,
                description: "The user email",
                example: "elevate@example.com",
                required: true,
              },
              password: {
                type: :string,
                description: "The user password",
                example: "123456",
                required: true,
              },
              password_confirmation: {
                type: :string,
                description: "The user password confirmation",
                example: "123456",
                required: true,
              },
              username: {
                type: :string,
                description: "User's username",
                example: "username",
                required: true,
              },
              full_name: {
                type: :string,
                description: "User's full name",
                example: "John Doe",
                required: true,
              }
            },
          }
        }
      }

      let(:request_body) {
        {
          user: {
            email: "elevate@example.com",
            full_name: "John Doe",
            username: "john_doe",
            password: "password",
            password_confirmation: "password",
          }
        }
      }

      response "201", "Created" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
          expect(data).to include(
            "user" => hash_including(
              "email" => "elevate@example.com",
              "username" => "john_doe",
              "full_name" => "John Doe",
            )
          )
          expect(data).to_not include(
            "user" => hash_including("stats" => anything)
          )
        end
      end

      response "422", "Unprocessable Entity" do
        let(:request_body) {
          {
            user: {
              password: "password",
              password_confirmation: "password",
            }
          }
        }

        run_test!
      end
    end
  end

  path "/api/user" do
    let!(:user) { User.make!(email: "elevate@example.com", password: "password", password_confirmation: "password") }
    let!(:api_key) { "Bearer #{Session.make!(user: user).token}" }
    let!(:Authorization) { api_key }
    let!(:game) { Game.make! }
    let!(:game_event) { GameEvent.make!(game: Game.make!(category: :math), user: user, occurred_at: Time.current - 1.day) }
    let!(:game_event2) { GameEvent.make!(game: Game.make!(category: :reading), user: user, occurred_at: Time.current - 2.day) }
    let!(:game_event3) { GameEvent.make!(game: Game.make!(category: :writing), user: user, occurred_at: Time.current - 4.day) }
    let!(:game_event4) { GameEvent.make!(game: Game.make!(category: :speaking), user: user, occurred_at: Time.current - 5.day) }
    let!(:game_event5) { GameEvent.make!(game: Game.make!(category: :speaking), user: user, occurred_at: Time.current - 6.day) }
    let!(:game_event6) { GameEvent.make!(game: Game.make!(category: :speaking), user: user, occurred_at: Time.current - 7.day) }

    get "show user stats" do
      tags "Users"
      security [JWT: []]
      parameter name: "Content-Type", default: "application/json", :in => :header, required: true

      response "200", "OK" do
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to_not be_empty
          expect(data["user"]).to include(
            "email" => "elevate@example.com",
            "username"=> anything,
            "full_name"=> anything,
            "stats"=> hash_including(
              "total_games_played"=>6,
              "total_math_games_played"=>1,
              "total_reading_games_played"=>1,
              "total_writing_games_played"=>1,
              "total_speaking_games_played"=>3,
              "current_streak_in_days"=>2
            )
          )
        end
      end

      response "401", "Unathorized" do
        let!(:Authorization) { "Bearer invalid_token" }
        let(:id) { user.id }
        run_test! 
      end

      response "401", "Unathorized" do
        let!(:Authorization) { nil }
        let(:id) { user.id }
        run_test! 
      end

      response "401", "Unathorized" do
        let!(:api_key) { "Bearer #{Session.make!(user: user, expiry_at: Time.current - 3.year).token}" }
        let!(:Authorization) { api_key }
        let(:id) { user.id }
        run_test! 
      end
    end
  end
end
