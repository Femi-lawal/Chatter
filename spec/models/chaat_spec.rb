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
require "rails_helper"

RSpec.describe Chaat, type: :model do
  fixtures :accounts

  let(:account) { accounts(:fixture_account_1) }

  subject(:chaat) { account.chaats.build(chaat_body: "Lorem ipsum") }

  it { should respond_to(:chaat_body) }
  it { should respond_to(:account_id) }
  it { should respond_to(:account) }
  it { expect(chaat.account).to eq(account) }

  it { should be_valid }

  describe "when account_id is not present" do
    before { chaat.account_id = nil }
    it { should be_invalid }
  end

  describe "with blank chaat_body" do
    before { chaat.chaat_body = " " }
    it { should be_invalid }
  end

  describe "with chaat_body that is too long" do
    before { chaat.chaat_body = "a" * 141 }
    it { should be_invalid }
  end
end
