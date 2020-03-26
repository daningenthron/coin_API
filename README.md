MortgageHippo Coding Challenge: Coin-API
----------------------------------------

Per the code challenge instructions, Coin-API is a RESTful Rails JSON API built on Postgres that tracks deposit and withdrawal transactions, and maintains a list of admins that can be alerted when coin supplies get low. The README will describe the API endpoints and a few additional steps I took in setting this up.

- URL: https://mh-coin-api.herokuapp.com
- Git repo: https://github.com/daningenthron/mortgagehippo_code_challenge

Gems
----

For testing I used RSpec, with Shoulda Matchers for some specs. FactoryBot and Faker generate test and seed data. Database Cleaner was used for testing and seeding the DB during development, but was removed from the seeds file for production. Active Model Serializers is configured to render the data in the json:api standard, and Delayed Job handles the async email send. I also used Pry for debugging, and enabled Rack-CORS for cross-origin requests.

Authentication
--------------

Rather than an access token, I created an ApiKey resource so a user can create a new key, which can then be entered as a request header `X-Api-Key`. Each request is validated via ApplicationController. As a modicum of security, the API user's email is also documented, which allows this to tie into the Admin resource (see below).


Resources & Endpoints
---------------------

NOTE: Enter an API key with the request header `X-Api-Key`. The key `test-key` is seeded.

Each resource features RESTful GET/POST/PUT/DELETE routes, with the exception of transactions, which does not allow PUT and DELETE calls. Additional calls are detailed below.

1. Coins
  - GET /coins - View all coins
  - GET /coins/:id - View a single coin
  - GET /coins/total - View total value of all coins
  - POST /coins - Create a new coin (this takes value attribute only, and assigns the name of the coin)
  - PUT /coins/:id - Update attributes (takes value only, and updates name)
  - DELETE /coins/:id - Delete a coin from the system

2. API Keys
  - GET /api_keys - Shows associated transaction ids
  - GET /api_keys/:id - Shows associated transaction details
  - POST /api_keys 
  - PUT /api_keys/:id
  - DELETE /api_keys/:id

  Note: GET and PUT will create Admin records if the 'admin' column is true

3. Admins

  - GET /admins
  - GET /admins/:id
  - POST /admins
  - PUT /admins/:id
  - DELETE /admins/:id

4. Transactions

  - GET /txns - Allows for an api_key_id param to filter by API user (/txns?api_key_id=1)
  - GET /txns/:id
  - POST /txns - Creates a transaction. Takes two params, txn_type (deposit/withdrawal) and value.
    - Deposits create a coin
    - Withdrawals fail if there are no coins of the requested type in the system. If the coin does exist, the first coin of that value is destroyed. Since the transaction contains the coin id, I removed the foreign key constraint so that if a coin is destroyed, the API can still show when it was deposited and withdrawn.

Mailers
-------

A single mailer is sent to all admins when a withdrawal brings the amount of a coin to under 4 of that type. This is generated through Rails by Action Mailer, and scheduled via ActiveJob. For the async send, while Sidekiq is generally faster, setting up a Redis instance does not fit the scale of the project, so I used Delayed Job.

Concerns / Helpers
------------------

Controller concerns: 
- JsonResponse - sets a default status code of 200 for responses
- ExceptionHandler - rescue methods to return error messages through responses

Spec support:
- JsonParser - DRYs the json parsing, brings below top level of response
- active_job.rb - RSpec config for Active Job; clears queue between tests

Test and development config files were edited to set up ActionMailer and ActiveJob.