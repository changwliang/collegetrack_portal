require 'rails_helper'

describe SalesforceController do

  before :each do
    login_admin
  end

  describe 'save_password' do
    it 'should redirect to login page' do
        post :save_password, :confirm_password => {:confirm_password => "asdfasdf"}, :password => {:password => "asdfasdf"}, :token => {:token => "token"}
        expect(response).to redirect_to root_path
    end

    it 'should update the password' do
      ENV['SALESFORCE_PASSWORD'] = 'outdated'
      post :save_password, :confirm_password => {:confirm_password => "asdfasdf"}, :password => {:password => "asdfasdf"}, :token => {:token => "token"}
      expect(ENV['SALESFORCE_PASSWORD']).to eq("asdfasdf")
      expect(ENV['SALESFORCE_SECURITY_TOKEN']).to eq("token")
    end
  end

  describe 'reset salesforce' do
    it 'should redirect to email page' do
        get :reset_salesforce
        expect(response).to redirect_to email_index_path
    end
  end

end