# By using the symbol ':user', we get Factory Girl to simulate the User model
FactoryGirl.define do
  factory :user do
    name                   "Test User"
    username               "testuser"
    email                  "example@test.com"
    password               "foobar"
    password_confirmation  "foobar"
  end
end
