require 'spec_helper'

describe AfpShareConfiguration do
  let('config') { described_class.new }
  subject { config }

  it 'queries for AfpShareService' do
    SharedFolderService.should_receive('where')\
      .with(service_class: 'AfpShareService')\
      .and_return([])
    subject.render
  end

  context 'no shares' do
    before { config.stub('load_shares').and_return([]) }
    its('config') { should be_empty }
  end

  context 'shares' do
    let('share_a') do
      build(:shared_folder_service)
    end
    let('share_b') do
      build(:shared_folder_service).tap do |s|
        s.shared_folder.name = 'Bar'
        s.shared_folder.path = '/bar'
        s.options[:time_machine] = false
      end
    end
    before { config.stub('load_shares') { [ share_a, share_b ] } }

    its('config') { should_not be_empty }
    its('config') do
      should == {'Bar' => { 'path' => '/bar', 'time_machine' => false },
                 'System' => {'path'=>'/', 'time_machine' => false } }
    end
  end
end
