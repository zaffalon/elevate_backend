class AddCalculateStreakFunction < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION calculate_streak(user_uuid text)
      RETURNS TABLE(last_streak_date date, sequential_days bigint) AS $$
      BEGIN
      RETURN QUERY
      WITH daily_events AS (
          SELECT occurred_at::date AS event_date
          FROM game_events
          WHERE game_events.user_id = user_uuid::uuid and type = 0
          GROUP BY occurred_at::date
      ),
      streaks AS (
          SELECT
              event_date,
              event_date - (ROW_NUMBER() OVER (ORDER BY event_date) || ' days')::interval AS streak_group
          FROM daily_events
      )
      SELECT
          MAX(event_date) as last_streak_date, COUNT(*) AS sequential_days
      FROM streaks
      GROUP BY streak_group
      ORDER BY MAX(event_date) DESC
      LIMIT 1;
      END; $$ LANGUAGE plpgsql;
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION IF EXISTS calculate_streak(text);
    SQL
  end
end
