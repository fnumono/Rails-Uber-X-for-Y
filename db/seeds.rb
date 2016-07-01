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

la = ZoomOffice.create!(longName: 'Los Angeles', shortName: 'Los Angeles')
sd = ZoomOffice.create!(longName: 'San Diego', shortName: 'San Diego')
sf = ZoomOffice.create!(longName: 'San Francisco', shortName: 'San Francisco')

Admin.create!(email: 'superadmin@zoomerrands.com', password: '12345678', password_confirmation: '12345678')
Admin.create!(email: 'la.admin@zoomerrands.com', password: '12345678', password_confirmation: '12345678', zoom_office: la)
Admin.create!(email: 'sd.admin@zoomerrands.com', password: '12345678', password_confirmation: '12345678', zoom_office: sd)

client = Client.new(email: 'client@zoomerrands.com', password: '12345678', zoom_office: la)
client.skip_confirmation!
client.save!

provider = Provider.new(email: 'provider@zoomerrands.com', password: '12345678', \
							 phone1: '+8613714486044', zoom_office: la, active: true)
provider.skip_confirmation!
provider.save!


Coupon.create!(code: '12345', discount_percent: '10', description: 'Save 10 percent')
Coupon.create!(code: 'ABCDE', discount_percent: '30', description: 'Save 30 percent')    

Fee.create!(percent: 5, cent: 0)
