# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Type.create!(name: 'Dog walker', comment: 'Walk dog for an hour')
Type.create!(name: 'Cleaner', comment: 'clean house')
Type.create!(name: 'Decorating', comment: 'decorate garden')
Type.create!(name: 'Delivery', comment: 'Deliver pizza')
Type.create!(name: 'Clerical', comment: 'Work as clerck')
Type.create!(name: 'Errands', comment: 'Some errands')
Type.create!(name: 'Grocery', comment: 'Go grocery for client')
Type.create!(name: 'Pets', comment: 'Care pets')

Superadmin.create!(email: 'superadmin@zoomerrands.com', password: 'password', password_confirmation: 'password')
