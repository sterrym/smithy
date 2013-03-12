# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page, :class => 'Smithy::Page' do
    template
    title { Faker::Lorem.words(2).join(' ') }
    description { Faker::Lorem.sentence }
    keywords { Faker::Lorem.words(10).join(' ') }
    published_at 1.day.ago
  end
end
