FactoryGirl.define do

  factory :user do
    sequence(:name){|n|   "factory_user_#{n}"}
    password              "factory_password"
    password_confirmation "factory_password"
  end

  factory :lobby do
    sequence(:name){|n|  "factory_name_#{n}"}
    user
  end
end
