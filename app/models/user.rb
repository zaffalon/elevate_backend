class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :sessions
  has_many :game_events

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true

  def calculate_streak
    last_streak_date, sequential_days = StreakCalculator.calculate_for(self)
    return 0 unless last_streak_date

    is_active_streak = last_streak_date >= (Date.current - 1.day)
    is_active_streak ? sequential_days : 0
  end

  def stats_by_category
    self.game_events.joins(:game).group('games.category').count
  end
end
