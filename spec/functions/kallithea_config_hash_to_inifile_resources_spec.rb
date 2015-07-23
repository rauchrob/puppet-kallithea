require 'spec_helper'

describe 'kallithea_config_hash_to_inifile_resources' do

  context 'empty hash' do
    it { should run.with_params({}).and_return({}) }
  end

  context 'simple non-empty hash' do
    input = { sec1: { key1: :val1 } }

    it { should run.with_params(input).and_return({
      'sec1/key1' => { 'ensure' => 'present', 'section' => 'sec1', 'setting' => 'key1', 'value' => 'val1', }
    })}
  end

  context 'complex hash' do
    input = { 
      sec1: { key1: :val1, key2: :val2, }, sec2: { key3: :val3, },
     } 

    it { should run.with_params(input).and_return({
      'sec1/key1' => { 'ensure' => 'present', 'section' => 'sec1', 'setting' => 'key1', 'value' => 'val1', },
      'sec1/key2' => { 'ensure' => 'present', 'section' => 'sec1', 'setting' => 'key2', 'value' => 'val2', },
      'sec2/key3' => { 'ensure' => 'present', 'section' => 'sec2', 'setting' => 'key3', 'value' => 'val3', },
    })}
  end

end
