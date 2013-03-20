
production-seed:
	@RAILS_ENV=production rake db:seed

production-start:
	@rails s --environment=production