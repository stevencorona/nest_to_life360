# Nest to Life360 API Wrapper

This connects your Life360 account to your Nest API.

How to run:

1. Create a `.env` file and fill in the following variables.

        LIFE360_CIRCLE=xxxx
        LIFE360_PLACE=xxxx
        LIFE360_TOKEN=xxxx
        NEST_EMAIL=you@domain.com
        NEST_PASSWORD=password

2. Run `bundle install`

3. Run `bundle exec foreman start`

4. Register `http://app/webhook` with the Life360 Webhook API.
