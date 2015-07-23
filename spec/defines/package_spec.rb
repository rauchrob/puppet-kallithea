require 'spec_helper'

describe 'kallithea::package' do

  default_params = {
    :venv => '/my/venv',
  }

  context "with default parameters" do
    let(:title) { 'mypackage' }
    let(:params) { default_params }

    it { should contain_python__pip('mypackage@/my/venv').with_pkgname('mypackage') }
  end

  context "with version specified" do
    let(:title) { 'mypackage' }
    let(:params) { default_params.merge({:version => 'x.y.z' }) }

    it { should contain_python__pip('mypackage@/my/venv').with_pkgname('mypackage==x.y.z') }
  end

end
