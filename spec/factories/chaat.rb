# frozen_string_literal: true

FactoryBot.define do
  factory :chaat do
    sequence(:chaat_body) { Faker::Quote.famous_last_words }
    account
  end
end
