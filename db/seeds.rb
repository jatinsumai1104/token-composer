# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10000.times.each do
  Token.create({blocked: true, blocked_at: Time.zone.now, alive_till: Time.zone.now + 5.minutes, deleted: true})
end
Token.create({alive_till: Time.zone.now + 5.minutes})

Token.create({alive_till: Time.zone.now + 5.minutes})
Token.create({blocked: true, blocked_at: Time.zone.now, alive_till: Time.zone.now + 5.minutes})
Token.create({alive_till: Time.zone.now + 5.minutes})
