class StreakCalculator
    def self.calculate_for(user)
        sql = <<-SQL
            SELECT * FROM calculate_streak('#{user.id}')
        SQL
        result = ActiveRecord::Base.connection.execute(sql)
        last_streak_date = result.first&.dig("last_streak_date")&.to_date
        sequential_days = result.first&.dig("sequential_days")&.to_i

        [last_streak_date, sequential_days]
    rescue StandardError => e
        Rails.logger.error("StreakCalculator Error for user #{user.id}: #{e.message}")
        [nil, 0]
    end
end