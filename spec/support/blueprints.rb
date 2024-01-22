require "machinist/active_record"

User.blueprint do
  email { "#{sn}@example.com" }
  password { "123456" }
  password_confirmation { "123456" }
  username { "username#{sn}" }
  full_name { "full_name#{sn}" }
end

Session.blueprint do
    user { User.make! }
    expiry_at { Time.current + Session::TTL }
end

Game.blueprint do
    name { "Game #{sn}" }
    url { "https://www.example.com" }
    category { 0 }
end

GameEvent.blueprint do
    game { Game.make! }
    user { User.make! }
    occurred_at { Time.current }
    type { 0 }
end