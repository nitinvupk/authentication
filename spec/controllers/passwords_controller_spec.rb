require 'rails_helper'

RSpec.describe PasswordsController, type: :controller do
  describe 'POST #create' do
    it 'returns email not found' do
      post :create, params: { email: '' }
      expect(flash[:alert]).to eq('Email not found.')
    end

    it 'returns email address not found' do
      post :create, params: { email: 'someone@example.com' }
      expect(flash[:alert]).to eq('Email not found.')
    end
  end

  describe "PUT #update" do
    it 'returns ok when all is fine' do
      user = create(:user)
      user.create_reset_digest
      put :update, params: { id: user.reset_token, email: user.email, password: 'Foobar@buz', password_confirmation: 'Foobar@buz' }
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq('Your password has been changed successfully.')
    end

    it "returns error password field is missing" do
      user = create(:user)
      user.create_reset_digest
      put :update , params: {id: user.reset_token, email: user.email, password_confirmation: 'Foobar@buz' }
      expect(response).to have_http_status(200)
      expect(flash[:notice]).to eq('Password is blank.')
    end

    context 'user is not valid' do
      it 'returns the error if user is not found by email' do
        put :update, params: {id: 'invalid', email: 'example@example.com', password: 'Foobar@buz', password_confirmation: 'Foobar@buz' }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('You are not authorize to perform this action.')
      end

      it 'returns the error if user reset token is not valid' do
        user = create(:user)
        user.create_reset_digest
        put :update, params: {id: 'invalid', email: user.email, password: 'Foobar@buz', password_confirmation: 'Foobar@buz' }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('You are not authorize to perform this action.')
      end
    end

    context 'Token expiration' do
      it 'returns the error after 2 hours' do
        user = create(:user)
        user.create_reset_digest
        user.update_attribute(:reset_sent_at, Time.zone.now - 7.hours)
        put :update, params: { id: user.reset_token, email: user.email, password: 'Foobar@buz', password_confirmation: 'Foobar@buz' }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('Reset password token has been expired or invalid')
      end
    end
  end
end
