require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:user) { }

  subject(:ability) { described_class.new(user) }

  describe 'base permissions for everything' do
    context 'with no user' do
      it 'should not be able to manage base permissions for everything' do
        is_expected.to be_able_to(:create, Session)
        is_expected.to be_able_to(:create, User)

        is_expected.to_not be_able_to(:read, User)
        is_expected.to_not be_able_to(:read, Game)
        is_expected.to_not be_able_to(:create, GameEvent)
      end
    end
  end

  describe 'base permissions for users' do
    context 'with user' do
      let!(:user) { User.make! }
      let!(:session) { Session.make!(user: user) }

      it 'should be able to manage base user permissions' do
        is_expected.to be_able_to(:create, Session)
        is_expected.to be_able_to(:create, User)

        is_expected.to be_able_to(:show, User)
        is_expected.to be_able_to(:index, Game)
        is_expected.to be_able_to(:create, GameEvent)
      end
    end
  end
end
