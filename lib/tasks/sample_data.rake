#!/bin/env ruby
# encoding: utf-8
require 'active_support'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end  
    
def make_users 
  admin = User.create!(name: "Александр",
                         surname: "Балакирев",
                         middle_name: "Владимирович",
                         birthdate: "23.01.1982",
                         city: "Kyiv",
                         phone: "+38(044)444-5555",
                         gender: "M", 
                         email: "example@example.org",
                         password: "foobar",
                         password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    surname = "Антонов-{n+1}"
    middle_name = "Антонович-{n+1}"
    birthdate = "04.08.1978-#{n+1}"
    city = "Киев"
    phone = "+38(044)444-5678"
    gender = "M"
    email = "example-#{n+1}@example.org"
    password  = "password"
    User.create!(name: name,
                 surname: surname,
                 middle_name: middle_name,
                 birthdate: birthdate,
                 city: city,
                 phone: phone,
                 gender:gender,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end