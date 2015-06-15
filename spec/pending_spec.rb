require 'spec_helper'

describe Patches::Pending do
  before do
    allow(Patches).to receive(:default_path).and_return(Pathname.new('/tmp/'))
  end

  context 'path' do
    specify { expect(subject.path).to eql(Patches.default_path) }
  end

  context 'empty each' do
    before do
      allow(subject).to receive(:files).and_return([])
    end

    specify { expect(subject.each).to be_empty }
  end

  context 'already run each' do
    before do
      allow(subject).to receive(:files).and_return(['test.rb'])
      allow(subject).to receive(:already_run?).and_return(true)
    end

    specify { expect(subject.to_a).to be_empty }
  end

  context 'actual pending' do
    before do
      allow(subject).to receive(:files).and_return(["test1234.rb"])
    end

    specify { expect(subject.to_a).to_not be_empty }
  end
end
