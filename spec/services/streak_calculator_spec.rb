require 'rails_helper'

RSpec.describe StreakCalculator, type: :model do
  let(:user) { User.make! }

  describe '.calculate_for' do
    context 'when the method runs successfully' do
      it 'returns last streak date and sequential days' do
        
        allow(ActiveRecord::Base.connection).to receive(:execute).and_return([{"last_streak_date" => Date.today, "sequential_days" => 5}])

        last_streak_date, sequential_days = StreakCalculator.calculate_for(user)

        expect(last_streak_date).to eq(Date.today)
        expect(sequential_days).to eq(5)
      end
    end

    context 'when the method raises an error' do
      it 'logs the error and returns nil and 0' do
        allow(ActiveRecord::Base.connection).to receive(:execute).and_raise(StandardError.new("Some error"))

        expect(Rails.logger).to receive(:error).with("StreakCalculator Error for user #{user.id}: Some error")

        last_streak_date, sequential_days = StreakCalculator.calculate_for(user)

        expect(last_streak_date).to be_nil
        expect(sequential_days).to eq(0)
      end
    end
  end
end