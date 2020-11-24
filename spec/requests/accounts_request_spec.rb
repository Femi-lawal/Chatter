# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Accounts", type: :request do
  fixtures :accounts
  let(:account) { accounts(:fixture_account_1) }

  describe "#index" do
    it "has a 200 status code" do
      get accounts_path
      expect(response.status).to eq(200)
    end
  end

  describe "#show" do
    it "has a 200 status code" do
      get account_path(account.account_name)
      expect(response.status).to eq(200)
    end
  end

  describe "#new" do
    it "has a 200 status code" do
      get new_account_path
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    it "creates new account" do
      post accounts_path, params: { account: FactoryBot.attributes_for(:account) }
      expect(response.status).to eq(302)
    end

    describe "Account already exists" do
      it "doesn't create new account" do
        post accounts_path, params: { account: FactoryBot.attributes_for(:account, email: account.email) }
        expect(response.status).to eq(200)
      end
    end
  end

  describe "#destroy" do
    context "no log in" do
      it "doen't delete account" do
        delete account_path(account.account_name)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "log in" do
      before { log_in account, no_capybara: true }
      it "deletes account" do
        expect { delete account_path(account.account_name) }.to change(Account, :count).by(-1)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "#update" do
    context "no log in" do
      it "doen't update account" do
        patch account_path(account.account_name)
        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "log in" do
      let(:updated_account) { FactoryBot.attributes_for(:account) }
      before { log_in account, no_capybara: true }
      it "updates account" do
        patch account_path(account.account_name), params: { account: updated_account }
        expect(response.status).to eq(302)
        expect(account.reload.name).to eq(updated_account[:name])
        expect(account.reload.email).to eq(updated_account[:email])
      end
    end
  end
end
