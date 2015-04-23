# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

years =* (1999...2015)
models = ['Escort', 'Focus', 'F-150', 'Fiesta', 'Escape', 'Mustang', 'Explorer', 'Bronco']
price =* (5000...50000)

for i in 1..1000
  Car.create!(year: years.sample,
              make: 'Ford',
              model: models.sample,
              date_sold: Faker::Date.between(Date.new(2013,04,22), Date.today),
              price: price.sample)
end
