require 'spec_helper'

describe Patches::Runner do
  let(:examples_path) { Pathname.new(File.absolute_path(File.join(File.dirname(__FILE__), 'example/'))) }
  let(:patch_path) { File.join(examples_path, '201512123012_test_patch.rb') }
  let(:base) { File.basename(patch_path) }

  before do
    allow(Patches).to receive(:default_path).and_return(examples_path)
  end

  context 'patches' do
    specify { expect(subject.path).to eql(Patches.default_path) }
    specify do
      expect(subject).to receive(:pending).and_return([patch_path])
      expect(subject).to receive(:complete!).with(base)
      expect(subject.perform).to_not be_empty
    end
  end

  context 'invalid patch' do
    specify do
      expect(subject).to receive(:pending).and_return(['test.rb'])
      expect {
        subject.perform
      }.to raise_error(Patches::Runner::UnknownPatch)
    end
  end
end


