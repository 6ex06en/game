require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user)}

  describe "#leave_lobby" do

    let!(:lobby){FactoryGirl.create(:lobby, user: user)}
    before(:each) { user2.join_lobby(lobby.id) }

    it "when guest leave lobby must be success" do
      user2.leave_lobby
      user2.reload
      expect(user2.guest_lobby).to be_nil
    end

    it "when owner leave lobby must be fail" do
      user.leave_lobby
      user.reload
      expect(user.lobby).to eq lobby
    end

    describe "#owner_lobby?" do

      it "when owner must be success" do
        expect(user.owner_lobby?).to be_truthy
      end

      it "when not owner must be fail" do
        expect(user2.owner_lobby?).to be_falsey
      end
    end
  end
end
