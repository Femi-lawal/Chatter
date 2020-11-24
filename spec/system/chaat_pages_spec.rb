# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Chaat pages", type: :system do
  subject { page }

  # NOTE: Use `let!` to avoid `exception: #<BCrypt::Errors::InvalidHash: invalid hash>`
  let!(:account) { FactoryBot.create(:account) }
  before { log_in account }

  describe "show all chaats" do
    let!(:chaat1) { FactoryBot.create(:chaat, account: account, chaat_body: "Harakiri") }
    let!(:chaat2) { FactoryBot.create(:chaat, account: account, chaat_body: "Samurai") }
    let!(:chaat3) { FactoryBot.create(:chaat, account: account, chaat_body: "Ninja") }
    let!(:chaat4) { FactoryBot.create(:chaat, account: account, chaat_body: "a" * 70) }

    before { visit chaats_path }

    it { should have_selector("h2", text: "Chaats") }
    it { should have_chaat_body(chaat1.chaat_body) }
    it { should have_chaat_body(chaat2.chaat_body) }
    it { should have_chaat_body(chaat3.chaat_body) }
    it { should have_chaat_body(chaat4.chaat_body) }

    describe "screenshot", js: true do
      it { page.save_screenshot "chaats.png" }
    end
  end

  describe "chaat creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a chaat" do
        expect { click_button "Post" }.not_to change(Chaat, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_chaat_body("can't be blank") }
      end
    end

    describe "with valid information" do
      before { fill_in "chaat_chaat_body", with: "Lorem ipsum" }
      it "should create a chaat" do
        expect { click_button "Post" }.to change(Chaat, :count).by(1)
      end
    end
  end

  describe "chaat destroy" do
    before { FactoryBot.create(:chaat, account: account) }

    describe "as correct account" do
      before { visit root_path }

      it "should delete a chaat" do
        expect { click_link "delete" }.to change(Chaat, :count).by(-1)
      end
    end
  end
end
