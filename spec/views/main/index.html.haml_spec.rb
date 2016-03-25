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

    end

  end
end
