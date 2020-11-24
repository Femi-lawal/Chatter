# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountRelationship, type: :model do
  fixtures :accounts

  let(:follower) { accounts(:fixture_account_1) }
  let(:followed) { accounts(:fixture_account_2) }

  subject(:account_relationship) { follower.active_account_account_relationships.build(followed_id: followed.id) }

  it { should be_valid }

  describe "follower methods" do
    it "has correct account_account_relationships" do
      expect(account_relationship.follower).to eq(follower)
      expect(account_relationship.followed).to eq(followed)
    end
  end

  describe "when followed id is not present" do
    before { account_relationship.followed_id = nil }
    it { should be_invalid }
  end

  describe "when follower id is not present" do
    before { account_relationship.follower_id = nil }
    it { should be_invalid }
  end
end
