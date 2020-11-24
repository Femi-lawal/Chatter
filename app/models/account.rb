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
class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chaats, dependent: :destroy
  has_many :active_account_relationships, class_name:  "AccountRelationship",
                                  foreign_key: "follower_id",
                                  inverse_of: :follower,
                                  dependent: :destroy
  has_many :passive_account_relationships, class_name: "AccountRelationship",
                                   foreign_key: "followed_id",
                                   inverse_of: :followed,
                                   dependent: :destroy
  has_many :following, through: :active_account_relationships, source: :followed
  has_many :followers, through: :passive_account_relationships, source: :follower

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true, if: ->(u) { u.password.present? }
  validates :account_name, uniqueness: true

  def to_param
    account_name
  end

  def feed
    # NOTE: `chaats.or` doesn't work, so use `Chaat.where`
    Chaat.where(account_id: id).or(Chaat.where(account_id: active_account_relationships.select(:followed_id)))
  end

  def following?(other_account)
    active_account_relationships.find_by(followed_id: other_account.id)
  end

  def follow!(other_account)
    active_account_relationships.create!(followed_id: other_account.id)
  end

  def unfollow!(other_account)
    active_account_relationships.find_by(followed_id: other_account.id).destroy!
  end

  class << self
  end

  private

end
