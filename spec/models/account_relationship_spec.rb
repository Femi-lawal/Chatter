# frozen_string_literal: true

# == Schema Information
#
# Table name: account_relationships
#
#  id          :integer          not null, primary key
#  status      :string           default("pending")
#  string      :string           default("pending")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_account_relationships_on_followed_id                  (followed_id)
#  index_account_relationships_on_followed_id_and_followed_id  (followed_id)
#  index_account_relationships_on_follower_id                  (follower_id)
#  index_account_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#  index_account_relationships_on_follower_id_and_follower_id  (follower_id)
#
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
