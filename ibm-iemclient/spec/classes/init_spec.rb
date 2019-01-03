require 'spec_helper'
describe 'iemclient' do

  context 'with defaults for all parameters' do
    it { should contain_class('iemclient') }
  end
end
