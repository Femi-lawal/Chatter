# frozen_string_literal: true

require "rails_helper"

RSpec.describe "accountPages", type: :system do
  subject { page }

  let(:account) { FactoryBot.create(:account) }

  describe "Show all accounts (/accounts)" do
    before do
      FactoryBot.create_list(:account, 2)
      visit accounts_path
    end

    it { should have_title("Accounts") }
    it { should have_chaat_body("Accounts") }
    it "should list each account" do
      Account.all.each do |account|
        expect(page).to have_selector("li", text: account.name)
      end
    end
  end

  describe "/new_account_registration" do
    before { visit new_account_registration_path }

    it { should have_title("Sign up") }
    it { should have_chaat_body("Sign up") }

    context "with valid information" do
      let(:account_email) { "account@example.com" }
      let(:account_name) { "Example Account Name" }

      before do
        fill_in "account_name",                  with: "example-account"
        fill_in "Name",                  with: account_name
        fill_in "Email",                 with: account_email
        fill_in "Password",              with: "foobar"
        fill_in "Password confirmation", with: "foobar"
      end

      it "should create a account" do
        expect { click_button "Sign up" }.to change(Account, :count).by(1)
      end

      describe "after saving the account" do
        before { click_button "Sign up" }

        it { should have_link("Log out") }
        it { should have_selector("div.alert.alert-success", text: "Welcome") }
        it { should have_title(account_name) }
      end
    end

    context "with invalid information" do
      it "should not create a account" do
        expect { click_button "Sign up" }.not_to change(Account, :count)
      end

      describe "error message" do
        before { click_button "Sign up" }

        it { should have_chaat_body "Name can't be blank" }
        it { should have_chaat_body "Email can't be blank" }
        it { should have_chaat_body "Password can't be blank" }
        it { should have_chaat_body "Password is too short" }
      end
    end
  end

  describe "edit" do
    before do
      log_in account
      visit edit_account_path(account)
    end

    describe "page" do
      it { should have_chaat_body("Update your profile") }
      it { should have_title("Edit account") }
      it { should have_link("Change", href: "http://gravatar.com/emails") }
      it { should have_link("Delete my account", href: account_path(account)) }
    end

    context "with invalid information" do
      before { click_button "Save changes" }

      it { should have_chaat_body("too short") }
    end

    context "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        fill_in "Password",              with: account.password
        fill_in "Password confirmation", with: account.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_link("Profile", href: account_path(account)) }
      it { should have_link("Setting", href: edit_account_path(account)) }
      it { should have_link("Log out", href: destroy_account_session_path) }
      it { should_not have_link("Log in", href: new_account_session_path) }
      it { should have_selector("div.alert.alert-success") }
      it { expect(account.reload.name).to  eq new_name }
      it { expect(account.reload.email).to eq new_email }
    end

    it "deletes account" do
      expect { click_link "Delete my account" }.to change(Account, :count).by(-1)
    end
  end

  describe "profile page (/account/:id)" do
    let!(:m1) { FactoryBot.create(:chaat, account: account, chaat_body: "Foo") }
    let!(:m2) { FactoryBot.create(:chaat, account: account, chaat_body: "Bar") }
    before { visit account_path(account) }

    it { should have_chaat_body(account.name) }
    it { should have_title(CGI.escapeHTML(account.name)) }

    it { should have_chaat_body(m1.chaat_body) }
    it { should have_chaat_body(m2.chaat_body) }
    it { should have_chaat_body(account.chaats.count) }

    it { should_not have_selector("textarea") }
    it { should_not have_field("chaat[chaat_body]") }

    describe "Log in account have chaat" do
      before do
        log_in account
        visit account_path(account)
      end

      it { should have_selector("textarea") }
      it { should have_field("chaat[chaat_body]") }
    end

    describe "follow/unfollow buttons" do
      let(:other_account) { FactoryBot.create(:account) }
      before { log_in account }

      describe "following a account" do
        before { visit account_path(other_account) }

        it "should increment the followed account count" do
          expect do
            click_button "Follow"
          end.to change(account.following, :count).by(1)
        end

        it "should increment the other account's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_account.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a account" do
        before do
          account.follow!(other_account)
          visit account_path(other_account)
        end

        it "should decrement the followed account count" do
          expect do
            click_button "Unfollow"
          end.to change(account.following, :count).by(-1)
        end

        it "should decrement the other account's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_account.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
  end

  describe "following/followers" do
    let(:other_account) { FactoryBot.create(:account) }
    before { account.follow!(other_account) }

    describe "followed accounts" do
      before do
        log_in account
        visit following_account_path(account)
      end

      it { should have_title("Following") }
      it { should have_selector("h2", text: "Following") }
      it { should have_link(other_account.name, href: account_path(other_account)) }
    end

    describe "followers" do
      before do
        log_in other_account
        visit followers_account_path(other_account)
      end

      it { should have_title("Followers") }
      it { should have_selector("h2", text: "Followers") }
      it { should have_link(account.name, href: account_path(account)) }
    end
  end
end
