require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LobbyHelper. For example:
#
# describe LobbyHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LobbiesHelper, type: :helper do

  let(:user){FactoryGirl.create(:user)}
  

  
  before(:each) { assign(:current_user, user) }

  describe "#has_lobby?" do

    it "must be nil" do
      expect(helper.has_lobby?).to be_falsey
    end

    it "must be truethy" do
      lobby1 = user.create_lobby(name: "test")
      expect(helper.has_lobby?).to be_truthy
      expect(user.lobby).to eq lobby1
    end

  end
  
  describe "#lobby_full?" do
    
    let!(:lobby){FactoryGirl.create(:lobby, user: user)}
    
    it "must be false" do
      expect(helper.lobby_full?(lobby)).to be_falsy
    end
  end

end
