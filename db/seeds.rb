# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
require 'database_cleaner'
require 'faker'

DatabaseCleaner.clean_with :truncation

ApiKey.create(email: 'coins@coin-api.com', key_str: SecureRandom.hex(3), admin: true)
ApiKey.create(email: 'info@coin-api.com', key_str: SecureRandom.hex(3), admin: true)
ApiKey.create(email: 'ops@coin-api.com', key_str: SecureRandom.hex(3), admin: true)
ApiKey.create(email: Faker::Internet.email, key_str: SecureRandom.hex(3), admin: false)
ApiKey.create(email: Faker::Internet.email, key_str: 'test-key', admin: false)

Admin.create(email: 'admin@coin-api.com')
Admin.create(email: 'info@coin-api.com')
Admin.create(email: 'ops@coin-api.com')
Admin.create(name: Faker::Name.name, email: Faker::Internet.email)
Admin.create(name: Faker::Name.name, email: Faker::Internet.email)

3.times do
  Txn.create_deposit({ txn_type: 'deposit', value: 1 }, ApiKey.first)
  Txn.create_deposit({ txn_type: 'deposit', value: 5 }, ApiKey.second)
  Txn.create_deposit({ txn_type: 'deposit', value: 10 }, ApiKey.last)
end

6.times do
  Txn.create_deposit({ txn_type: 'deposit', value: 25 }, ApiKey.first)
end

Txn.create_withdrawal({ txn_type: 'withdrawal', value: 1 }, ApiKey.first)
Txn.create_withdrawal({ txn_type: 'withdrawal', value: 5 }, ApiKey.first)
Txn.create_withdrawal({ txn_type: 'withdrawal', value: 10 }, ApiKey.second)
Txn.create_withdrawal({ txn_type: 'withdrawal', value: 25 }, ApiKey.last)

Delayed::Job.destroy_all
