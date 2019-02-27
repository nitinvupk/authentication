require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  let!(:user) { create(:user) }
  let(:valid_session) { {user_id: user.id} }

  describe "POST #create" do
    it "returns http success" do
      user = create(:user, password: 'Foobar@buz', password_confirmation: 'Foobar@buz')
      post :create, params: { email: user.email, password: 'Foobar@buz' }
      expect(flash[:notice]).to eq("Logged in!")
      expect(response).to have_http_status(302)
    end

    it "returns status as unauthorized" do
      user = create(:user, password: 'Foobar@buz', password_confirmation: 'Foobar@buz')
      post :create, params: { email: user.email, password: 'Foobar@bu' }
      expect(response).to have_http_status(200)
    end

    it "returns user does not exist" do
      post :create, params: { email: 'foo@example.com', password: 'Foobar@buz' }
      expect(flash[:alert]).to eq('Email or password is invalid')
    end
  end

  describe "POST #destroy" do
    it "returns http success" do
      delete :destroy, session: valid_session
      expect(flash[:notice]).to eq("Logged out!")
    end
  end
end
