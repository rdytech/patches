require 'spec_helper'

describe Patches do
  it 'has a version number' do
    expect(Patches::VERSION).not_to be nil
  end

  it 'default path' do
    expect(Rails).to receive(:root).and_return(Pathname.new('/tmp'))
    expect(Patches.default_path).to eql(Pathname.new('/tmp/db/patches/'))
  end

  context 'class name' do
    specify { expect(Patches.class_name('201203031234_class_name.rb')).to eql('ClassName') }
    specify { expect(Patches.class_name('201203031234_.rb')).to be_nil }
  end
end
