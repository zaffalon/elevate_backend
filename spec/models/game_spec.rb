require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:game_events) }

  it { should define_enum_for(:category).with_values(math: 0, reading: 1, speaking: 2, writing: 3) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:category) }
end
