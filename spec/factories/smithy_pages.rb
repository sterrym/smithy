# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page, :class => 'Smithy::Page' do
    template
    title { Faker::Lorem.words(2).join(' ') }
  end
end