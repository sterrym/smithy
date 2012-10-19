require 'spec_helper'

describe Tagcms::TemplateContainer do
  let(:one_container) { File.read(ENGINE_RAILS_ROOT.join('spec', 'fixtures', 'templates', 'foo.html.liquid')) }
  let(:three_containers) { File.read(ENGINE_RAILS_ROOT.join('spec', 'fixtures', 'templates', 'foo_bar_baz.html.liquid')) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:template) }
  it { should belong_to(:template) }
  it { should have_many(:pages).through(:template) }

  # containers are never managed directly - they are always
  # auto-created via the containers in the content of a template
  # therefore, we test the creation and destruction of containers
  # via the templates themselves
  context "a template with a single container" do
    let(:template) { FactoryGirl.create(:template, :content => one_container) }
    subject { template.containers }
    its(:size) { should == 1 }
    context "the first container" do
      subject { template.containers.first }
      its(:name) { should == 'foo' }
    end
    context "increased to 3 containers" do
      before do
        template.update_attribute(:content, three_containers)
      end
      its(:size) { should == 3 }
      specify { subject.map(&:name).should == %w(foo bar baz) }
    end
    context "reduced to 0 containers" do
      before do
        template.update_attribute(:content, '{{ no_containers }}')
      end
      its(:size) { should == 0 }
      specify { subject.map(&:name).should == [] }
    end
  end

  context "a template with a three containers" do
    let(:template) { FactoryGirl.create(:template, :content => three_containers) }
    subject { template.containers }
    its(:size) { should == 3 }
    specify { subject.map(&:name).should == %w(foo bar baz) }
    context "reduced to 1 containers" do
      before do
        template.update_attribute(:content, one_container)
      end
      its(:size) { should == 1 }
      specify { subject.map(&:name).should == %w(foo) }
    end
    context "reduced to 0 containers" do
      before do
        template.update_attribute(:content, '{{ no_containers }}')
      end
      its(:size) { should == 0 }
      specify { subject.map(&:name).should == [] }
    end
  end
end