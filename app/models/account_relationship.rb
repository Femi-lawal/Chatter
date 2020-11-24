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
class AccountRelationship < ApplicationRecord
  belongs_to :follower, class_name: "Account"
  belongs_to :followed, class_name: "Account"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
