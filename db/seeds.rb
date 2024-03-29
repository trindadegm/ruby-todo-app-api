# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do
    Task.create({
        owner: Faker::Number.number(digits: 7),
        title: Faker::Book.title,
        description: Faker::Lorem.sentence,
        status: "pending",
        visibility: "public"
    })
end