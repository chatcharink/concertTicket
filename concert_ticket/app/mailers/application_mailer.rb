class ApplicationMailer < ActionMailer::Base
  default from: "siamworldmusicfestival@gmail.com"
  layout "mailer"
  require 'mini_magick'
end
