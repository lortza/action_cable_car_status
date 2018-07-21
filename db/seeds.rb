# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

black = Color.find_or_create_by!(name: 'Black')
white = Color.find_or_create_by!(name: 'White')
silver = Color.find_or_create_by!(name: 'Silver')
red = Color.find_or_create_by!(name: 'Red')
burnt_umber = Color.find_or_create_by!(name: 'Burnt Umber')

Status.destroy_all
one = Status.create!(number: 1, name: 'delivered to lot')
two = Status.create!(number: 2, name: 'undergoing inspection')
three = Status.create!(number: 3, name: 'available to sell')
four = Status.create!(number: 4, name: 'sale pending')
five = Status.create!(number: 5, name: 'sold')
six = Status.create!(number: 6, name: 'missing')
seven = Status.create!(number: 7, name: 'at the bottom of the bay')
eight = Status.create!(number: 8, name: 'impounded')

Car.destroy_all
Car.create!([
  {make: 'Honda', model: 'Civic', color_id: black.id, status_id: one.id},
  {make: 'Oldsmobile', model: 'Cutlass Ciera', color_id: burnt_umber.id, status_id: six.id},
  {make: 'Ford', model: 'Bronco', color_id: white.id, status_id: two.id},
  {make: 'Ford', model: 'Gran Torino', color_id: red.id, status_id: seven.id},
  {make: 'Kia', model: 'Rio', color_id: silver.id, status_id: one.id},
  {make: 'Chevy', model: 'Silverado', color_id: red.id, status_id: one.id},
  {make: 'Ford', model: 'Focus', color_id: white.id, status_id: one.id}
])
