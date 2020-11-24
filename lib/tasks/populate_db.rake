# frozen_string_literal: true

namespace :db do
  desc "Create fake accounts and chaats"
  task populate_db: :environment do
    generate_account!
    generate_chaats!
    generate_account_relationships!
  end
end

def generate_account!
  (1..200).each do |n|
    name = Faker::Name.name
    account_name = name.parameterize
    email = "#{name}#{n}@femilawal.com"
    password = "password"
    Account.create!(
                 name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 account_name: account_name
                )
      p n
  end
end

def generate_chaats!
  accounts = Account.where('id is not 1')
  20.times do
    accounts.each { |account| account.chaats.create!(chaat_body: Faker::Lorem.sentence(word_count: 5)) }
    p 'iteration'
  end
end

def generate_account_relationships!
  accounts = Account.where('id is not 1')
  main_account  = accounts.first
  accounts.each { |followed| main_account.follow!(followed) }
  accounts.each { |follower| follower.follow!(main_account) }
end
