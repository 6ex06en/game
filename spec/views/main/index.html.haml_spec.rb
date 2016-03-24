require 'rails_helper'

RSpec.describe "main/index", type: :view do

  let(:user){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user)}

  describe "when login" do
    before(:each) { assign(:current_user, user)}

    describe "when no lobby" do

      it "must be welcome text" do
        render
        expect(rendered).to match(/Welcome/)
      end


      it "must be link join to lobby" do
        assign(:lobbies, [@lobbies])
        @lobbies = [user2.create_lobby(name: "first_lobby")]
        p "#{@lobbies.first.name} - it's a lobby"
        render
        expect(rendered).to match(/#{lobby.name}/)
      end

    end

  end
end
