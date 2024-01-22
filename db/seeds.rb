# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


if Game.count == 0 
    puts "Creating some games..."
    Game.create!(name: "Call of Duty", url: "https://www.callofduty.com/", category: :math)
    Game.create!(name: "Fortnite", url: "https://www.epicgames.com/fortnite/en-US/home", category: :reading)
    Game.create!(name: "Minecraft", url: "https://www.minecraft.net/en-us", category: :writing)
    Game.create!(name: "League of Legends", url: "https://na.leagueoflegends.com/en-us/", category: :speaking)
end