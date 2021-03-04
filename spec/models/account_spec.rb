# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                     :integer          not null, primary key
#  account_name           :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_accounts_on_confirmation_token    (confirmation_token) UNIQUE
#  index_accounts_on_email                 (email) UNIQUE
#  index_accounts_on_reset_password_token  (reset_password_token) UNIQUE
#  index_accounts_on_unlock_token          (unlock_token) UNIQUE
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  fixtures :accounts, :chaats

  subject(:account) do
    Account.new(name: 'femi', email: 'femi@femilawal.com',
             password: 'password', password_confirmation: 'password')
  end

  it { should respond_to(:name) }
  it { should respond_to(:account_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:chaats) }
  it { should respond_to(:feed) }
  it { should respond_to(:active_account_relationships) }
  it { should respond_to(:following) }
  it { should respond_to(:passive_account_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }

  describe 'when name is not present' do
    before { account.name = ' ' }
    it { should be_invalid }
  end

  describe 'when name is too long' do
    before { account.name = 'a' * 51 }
    it { should be_invalid }
  end

  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[account@foo,bar account.foo account@foo.]
      addresses << "too.long.email@address.com-#{'a' * 250}"
      addresses.each do |address|
        account.email = address
        expect(account).to be_invalid
      end
    end
  end

  describe 'when email format is valid' do
    it 'should be valid' do
      addresses = %w[account@foo.bar a+b@a.com toshi...1@a.b.c]
      addresses.each do |address|
        account.email = address
        expect(account).to be_valid
      end
    end
  end

  describe 'when email address is already taken' do
    before do
      account_with_same_email = account.dup
      account_with_same_email.email = account.email.upcase
      account_with_same_email.save
    end

    it { should be_invalid }
  end

  describe 'when password does not match confirmation' do
    before { account.password_confirmation = 'aaa' }
    it { should be_invalid }
  end

  describe 'with a password that is too short' do
    before { account.password = 'a' * 3 }
    it { should be_invalid }
  end

  describe 'return value of authenticate method' do
    before { account.save }
    let(:found_account) { Account.find_by(email: account.email) }

    describe 'with valid password' do
      it { should eq found_account.authenticate(account.password) }
    end

    describe 'with invalid password' do
      let(:account_for_invalid_password) { found_account.authenticate('invalid') }

      it { should_not eq account_for_invalid_password }
      it { expect(account_for_invalid_password).to be false }
    end
  end

  describe 'chaat associations' do
    before { account.save }

    let!(:old_chaat) { FactoryBot.create(:chaat, account: account, created_at: 3.day.ago) }
    let!(:new_chaat) { FactoryBot.create(:chaat, account: account, created_at: 5.hour.ago) }

    it 'should have the right chaats in the right order' do
      expect(account.chaats).to eq [new_chaat, old_chaat]
    end

    it 'should destroy associated chaats' do
      chaats = account.chaats
      account.destroy!
      chaats.each do |chaat|
        expect(Chaat.find_by(id: chaat.id)).to be_nil
      end
    end

    describe 'status' do
      let(:unfollowed_post) { chaats(:chaat) }
      let(:followed_account) { accounts(:fixture_account_2) }

      before do
        account.follow!(followed_account)
        3.times { followed_account.chaats.create!(chaat_body: Faker::Quote.famous_last_words) }
      end

      it 'includes chaats from the following account' do
        expect(account.feed).to include(newer_chaat)
        expect(account.feed).to include(older_chaat)
        expect(account.feed).not_to include(unfollowed_post)

        followed_account.chaats.each do |chaat|
          expect(account.feed).to include(chaat)
        end
      end
    end
  end

  describe 'following & followers' do
    let(:other_account) { accounts(:fixture_account_1) }

    before do
      account.save
      account.follow!(other_account)
    end

    describe 'following' do
      it { should be_following(other_account) }
      it { expect(account.following).to include(other_account) }
    end

    describe 'followers' do
      it { expect(other_account.followers).to include(account) }
    end
  end
end
