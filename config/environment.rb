# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Stui::Application.initialize!

Time::DATE_FORMATS[:user_datetime] = "%B %d, %Y at %k:%M"
