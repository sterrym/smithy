# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content_block, :class => 'Smithy::ContentBlock' do
    name { FFaker::Lorem.words(5).join(' ') }
  end
end
