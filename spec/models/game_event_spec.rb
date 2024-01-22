require 'rails_helper'

RSpec.describe GameEvent, type: :model do
  it { should belong_to(:game) }
  it { should belong_to(:user) }
  
  it { should define_enum_for(:type).with_values(COMPLETED: 0) }

  it { should validate_presence_of(:occurred_at) }
  it { should validate_presence_of(:type) }

  describe '#remove_user_caches' do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end
    
    let(:user) { User.make! }
    let(:game_event) { GameEvent.make!(user: user) }

    before do
      Rails.cache.write([user, 'stats'], 'cached data')
    end

    it 'removes the user stats from the cache after commit' do
      expect(Rails.cache.read([user, 'stats'])).to eq('cached data')
      game_event.run_callbacks(:commit)
      expect(Rails.cache.read([user, 'stats'])).to be_nil
    end
  end
end
