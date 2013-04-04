require 'spec_helper'

describe SharedFolder do
  context "empty object" do
    its(:valid?) { should be_false }
  end
  
  context "filled object" do
    subject { build :shared_folder }
    
    its(:valid?) { should be_true }
  end
  
  context "invalid path" do
    context "don't exist" do
      subject { build :shared_folder, path: "/aksjhdkjahsd" }
    
      its(:valid?) { should be_false }
    end

    context "no directory" do
      subject { build :shared_folder, path: Rails.root.join("config/boot.rb") }
    
      its(:valid?) { should be_false }
    end
  end
end
