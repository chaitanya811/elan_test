require 'spec_helper'
describe 'python_pip' do

  context 'with defaults for all parameters' do
    it { should contain_class('python_pip') }
  end
end
