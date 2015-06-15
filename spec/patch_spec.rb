require 'spec_helper'

describe Patches::Patch do
  let!(:patch) { Patches::Patch.create(path: 'test.rb') }
  specify { expect(subject.valid?).to be_falsey }

  context '#path_lookup' do
    specify { expect(described_class.path_lookup).to have_key(patch.path) }
  end
end
