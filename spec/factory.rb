FactoryGirl.define do
  factory :user do
    name "Александр"
    surname "Балакирев"
    middle_name "Владимирович"
    date_of_birth "23.01.1983"
    city "Киев" 
    phone "222-22-22"
    sex "M"
    email "example@example.com"
    image_url "image.jpg" 
    password "foobar" 
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
end