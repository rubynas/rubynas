require 'spec_helper'

shared_examples 'aptget-install' do |method|
  it 'should work' do
    subject.should_receive(:system).and_return(true)
    subject.send(method)
  end
  
  it 'can fail' do
    subject.should_receive(:system).and_return(false)
    expect { subject.send(method) }.to(
      raise_error(BaseInstaller::InstallError))
  end
end

shared_examples 'aptget-configure' do |method|
  it 'should work' do
    IO.stub(:popen)
    subject.send(method)
  end
  
  it 'can fail' do
    IO.stub(:popen)
    $?.stub(:exited?) { false }
    expect { subject.send(method) }.to(
      raise_error(BaseInstaller::ConfigurationError))
  end
end

describe DebianInstaller do
  subject { described_class.new('rubynas.com', 'admin', 'secret') }
  
  context '#prepare_install' do
    it_behaves_like 'aptget-install', :prepare_install
  end
  
  context '#install' do
    it 'should work' do
      subject.should_receive(:system).and_return(true)
      subject.install
    end
    
    it 'can fail' do
      subject.should_receive(:system).and_return(false)
      expect { subject.install }.to(
        raise_error(BaseInstaller::PackageError))
    end
  end
  
  context '#debconf' do
    it 'should work' do
      IO.stub(:popen)
      subject.debconf('ldap', 'password', :password, 'secret')
    end
    
    it 'can fail' do
      IO.stub(:popen)
      $?.stub(:exited?) { false }
      expect { subject.debconf('ldap', 'password', :password, 'secret') }.to(
        raise_error(BaseInstaller::ConfigurationError))
    end
  end
  
  context '#configure_ldap' do
    it_behaves_like 'aptget-configure', :configure_ldap
  end
  
  context '#install_ldap' do
    it_behaves_like 'aptget-install', :install_ldap
  end
  
  context '#configure_pam_auth' do
    it_behaves_like 'aptget-configure', :configure_pam_auth
  end
  
  context '#install_pam_auth' do
    it_behaves_like 'aptget-install', :install_pam_auth
  end
  
  pending '#configure_app' do
  end
  
  context '#install_app' do
    it_behaves_like 'aptget-install', :install_app
  end
end
