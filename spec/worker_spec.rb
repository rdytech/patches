require 'spec_helper'
require "patches/worker"

describe Patches::Worker do
  describe '#perform' do
    let(:runner) { instance_double(Patches::Runner, perform: true) }

    before do
      allow(Patches::Config.configuration).to receive(:application_version) { application_version }
      allow(Patches::Runner).to receive(:new) { runner }
    end

    context 'when application_version config is set' do
      let(:application_version) { '5828321' }

      context 'when application version matches' do
        it 'runs patches' do
          expect(runner).to receive(:perform)
          subject.perform('Patches::Runner', application_version: application_version)
        end
      end

      context 'when application_version does not match' do
        it 'does not run patches' do
          expect(runner).not_to receive(:perform)
          subject.perform('Patches::Runner', application_version: 'd8f190c')
        end

        it 'reschedules the job' do
          expect(Patches::Worker).to receive(:perform_in).with(1.minute, 'Patches::Runner', application_version: 'd8f190c')
          subject.perform('Patches::Runner', application_version: 'd8f190c')
        end
      end
    end

    context 'when application config is not set' do
      let(:application_version) { nil }

      it 'runs patches' do
        expect(runner).to receive(:perform)
        subject.perform('Patches::Runner', application_version: 'd8f190c')
      end
    end
  end
end
