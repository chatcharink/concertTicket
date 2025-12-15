require "sendgrid-ruby"

SendGridClient = SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid, :api_key))