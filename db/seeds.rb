# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.create!(:name => 'Jason Chern', :email => 'jason.chern93@gmail.com', :password => 'password', :role => 'Admin')
# User.create!(:name => 'Alison Lam', :email => 'alam@collegetrack.org', :password => 'password', :role => 'Admin')
# User.create!(:name => 'Peter Duong', :email => 'petrduong@gmail.com', :password => 'password', :role => 'Admin')
# User.create!(:name => 'Edward Huang', :email => 'shinyenhuang@gmail.com', :password => 'password', :role => 'Admin')
# User.create!(:name => 'Chang Liang', :email => 'changwliang@gmail.com', :password => 'password', :role => 'Admin')
# User.create!(:name => 'Kyle Chang', :email => 'hchang409@gmail.com', :password => 'password', :role => 'Admin')
# User.create!(:name => 'Jerry Uejio', :email => 'jerryuejio@gmail.com', :password => 'password', :role => 'Admin')

User.create!(:name => 'Hatim Khan', :email => 'hatimkhan@berkeley.edu', :password => 'password', :role => 'Admin')

User.create!(:name => 'Molly Zhai', :email => 'mmzhai@berkeley.edu', :password => 'password', :role => 'Admin')
User.create!(:name => 'Avi Frankl', :email => 'afrankl@berkeley.edu', :password => 'password', :role => 'Admin')

User.create!(:name => 'Clark Chen', :email => 'clark_chen@berkeley.edu', :password => 'password', :role => 'Admin')
#User.create!(:name => 'Dennis Xing', :email => 'yxing@berkeley.edu', :password => 'password', :role => 'Admin')
User.create!(:name => 'Brandon Chau', :email => 'brandonachau@berkeley.edu', :password => 'password', :role => 'Admin')

User.all.each do |u|
	#u.groups.create!(:name => 'High GPA', :filters => 'GPA > 3.5')
	u.groups.create!(:name => 'Low GPA', :filters => 'GPA < 2.5')
	u.groups.create!(:name => 'Oakland High GPA', :filters => 'Lives in Oakland, GPA > 3.1')
end
