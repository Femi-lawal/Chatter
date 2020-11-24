# frozen_string_literal: true

# == Schema Information
#
# Table name: chaats
#
#  id         :uuid             not null, primary key
#  chaat_body :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_chaats_on_account_id                 (account_id)
#  index_chaats_on_account_id_and_created_at  (account_id,created_at)
#
class Chaat < ApplicationRecord
  belongs_to :account
  before_create :set_id

  default_scope -> { order(created_at: :desc) }

  validates :chaat_body, presence: true, length: { maximum: 140 }
  validates :account_id, presence: true

  def set_id
    return if self.id.present?

    self.id = SecureRandom.uuid
  end

end
