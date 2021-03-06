require 'rails_helper'

RSpec.describe Smithy::Liquid::Tags::Nav do
  include_context "a tree of pages" # see spec/support/shared_contexts/tree.rb
  let(:site) { Smithy::Site.instance }
  subject { render_nav 'site' }

  it { is_expected.to eql navigation_for_depth_of_1 }

  context "a depth of 2" do
    subject { render_nav 'site', 'depth: 2' }
    it { is_expected.to eql navigation_for_depth_of_2 }
  end

  context "a depth of 0" do
    subject { render_nav 'site', 'depth: 0' }
    it { is_expected.to eql navigation_for_depth_of_0 }
  end

  context "a custom id" do
    subject { render_nav 'site', 'id: foo' }
    it { is_expected.to start_with '<ul id="foo"' }
    it { is_expected.to include '<li id="foo-page-1'}
  end

  context "with a selected page" do
    subject { render_nav 'site', 'active_class: foo', { :page => page1 } }
    let(:navigation) { navigation_for_depth_of_1.sub(/id="nav-page-1"/, 'id="nav-page-1" class="foo"')}
    it { is_expected.to eql navigation }
  end

  context "with a selected page and a custom class" do
    subject { render_nav 'site', '', { :page => page1 } }
    let(:navigation) { navigation_for_depth_of_1.sub(/id="nav-page-1"/, 'id="nav-page-1" class="on"')}
    it { is_expected.to eql navigation }
  end

  def render_nav(root = 'site', tag_options = '', registers = {})
    controller = double(ApplicationController)
    allow(controller).to receive_message_chain(:request, :path).and_return('/')
    expect(controller.request.path).to eq('/')
    registers = { :site => site, :page => home, :controller => controller }.merge(registers)
    liquid_context = ::Liquid::Context.new({}, {}, registers)
    ::Liquid::Template.parse("{% nav #{root} #{tag_options} %}").render(liquid_context).gsub(/\n|\s\s/, '')
  end

  let(:navigation_for_depth_of_0) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'nav', 'navigation_for_depth_of_0.html')).gsub(/\n|\s\s/, '') }
  let(:navigation_for_depth_of_1) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'nav', 'navigation_for_depth_of_1.html')).gsub(/\n|\s\s/, '') }
  let(:navigation_for_depth_of_2) { File.read(Smithy::Engine.root.join('spec', 'fixtures', 'nav', 'navigation_for_depth_of_2.html')).gsub(/\n|\s\s/, '') }
end
