# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Static Pages", type: :system do
  fixtures :accounts

  subject { page }

  describe "Home" do
    describe "for log in accounts" do
      let(:account) { FactoryBot.create(:account) }

      before do
        FactoryBot.create_list(:chaat, 2, account: account, chaat_body: Faker::Quote.famous_last_words)
        log_in account
        visit root_path
      end

      it "should render the account's feed" do
        account.feed.each do |item|
          should have_chaat_body(item.chaat_body)
        end
      end

      it { should have_title "Home" }
      it { should have_selector("textarea") }
      it { should have_field("chaat[chaat_body]") }

      describe "follower/following counts" do
        let(:other_account) { accounts(:fixture_account_1) }

        before do
          other_account.follow!(account)
          visit root_path
        end

        it { should have_link("0", href: following_account_path(account)) }
        it { should have_link("1", href: followers_account_path(account)) }
      end
    end
  end

  describe "Help" do
    before { visit help_path }
    it { should have_title "Help" }
  end

  describe "About" do
    before { visit about_path }
    it { should have_title "About" }
  end

  describe "Contact" do
    before { visit contact_path }
    it { should have_title "Contact" }
  end
end
