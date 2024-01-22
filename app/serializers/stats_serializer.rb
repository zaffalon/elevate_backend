class StatsSerializer < ApplicationSerializer

  attribute :total_games_played do |object|
    object.game_events.count
  end

  attribute :total_math_games_played do |object, params|
    params.dig(:stats_by_category, 'math') || 0
  end

  attribute :total_reading_games_played do |object, params|
    params.dig(:stats_by_category, 'reading') || 0
  end

  attribute :total_writing_games_played do |object, params|
    params.dig(:stats_by_category, 'writing') || 0
  end

  attribute :total_speaking_games_played do |object, params|
    params.dig(:stats_by_category, 'speaking') || 0
  end

  attribute :current_streak_in_days do |object|
    object.calculate_streak
  end
end
