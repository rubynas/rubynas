require 'spec_helper'

describe SharedFolderService do
  context "new shared folder service" do
    its(:valid?) { should be_false }
  end
  
  context "#service_class" do
    it "stores a service class" do
      subject.service_class = String
      subject.service_class.should == String
    end
  end
  
  context "with valid shared folder service" do
    subject { create(:shared_folder_service) }
    
    context "after loading" do
      before { subject.reload }
      
      its(:service_class) { should == AfpShareService }
      its(:options) { should include(time_machine: true) }
    end
  end
end
