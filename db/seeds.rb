# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



helpers = ActionController::Base.helpers

default_password = ENV['DEFAULT_PASSWORD'] || '1234'

User.destroy_all
admin_user = User.create( username: 'meister', email: 'meister@spacekace.com', first_name: 'Michael', last_name: 'Ferguson', status: 'active', role: 'admin', password: default_password )
admin_user = User.create( username: 'Gk', email: 'gk@gk.com', first_name: 'Gk', last_name: 'PP', status: 'active', role: 'admin', password: default_password )
