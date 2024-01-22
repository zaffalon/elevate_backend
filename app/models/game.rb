class Game < ApplicationRecord
    has_many :game_events

    enum :category, { math: 0, reading: 1, speaking: 2, writing: 3 }, validate: true

    validates :name, presence: true
    validates :url, presence: true
    validates :category, presence: true
end
