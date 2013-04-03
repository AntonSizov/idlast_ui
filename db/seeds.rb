# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def gen_password
  return (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a).shuffle[0,20].join
end

puts 'SETTING UP DEFAULT USER LOGIN'

user0 = User.new :name => 'IDLast.com', :email => 'idlast@idlast.com', :password => '987245jo8ug98rt4ji9g8'
user0.password = gen_password if Rails.env.production?
user0.save!
puts 'New user created: ' << user0.name

user1 = User.new :name => 'Anton Sizov', :email => 'a.sysoff@gmail.com', :password => 'administrator'
user1.password = gen_password if Rails.env.production?
user1.admin = true
user1.save!
puts 'New user created: ' << user1.name

user2 = User.new :name => 'iKatod', :email => 'ikatod@gmail.com', :password => 'ikatodikatod'
user2.password = gen_password if Rails.env.production?
user2.admin = true
user2.save!
puts 'New user created: ' << user2.name
