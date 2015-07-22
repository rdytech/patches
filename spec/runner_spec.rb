require 'spec_helper'

describe Patches::Runner do
  describe '#perform' do
    let(:examples_path) { Pathname.new(File.absolute_path(File.join(File.dirname(__FILE__), 'example/'))) }
    let(:base) { File.basename(patch_path) }

    before do
      allow(Patches).to receive(:default_path).and_return(examples_path)
      allow(Patches::Notifier).to receive(:notify_success).and_return(nil)
      allow(Patches::Notifier).to receive(:notify_failure).and_return(nil)
    end

    context 'with a failing patch' do
      let(:patch_path) { File.join(examples_path, '201512123012_failing_test_patch.rb') }

      specify do
        expect(Patches::Notifier).to receive(:notify_failure)
        expect {
          Patches::Runner.new.perform
        }.to raise_error
      end
    end

    context 'with a successful patch' do
      let(:patch_path) { File.join(examples_path, '201512123012_successful_test_patch.rb') }

      context 'patches' do
        specify { expect(subject.path).to eql(Patches.default_path) }
        specify do
          expect(subject).to receive(:pending).and_return([patch_path])
          expect(subject).to receive(:complete!).with(base)
          expect(Patches::Notifier).to receive(:notify_success)
          expect(subject.perform).to_not be_empty
        end
      end
    end

    context 'with an invalid patch' do
      let(:patch_path) { File.join(examples_path, '201512123012_successful_test_patch.rb') }

      specify do
        expect(subject).to receive(:pending).and_return(['test.rb'])
        expect {
          subject.perform
        }.to raise_error(Patches::Runner::UnknownPatch)
      end
    end
  end
end

