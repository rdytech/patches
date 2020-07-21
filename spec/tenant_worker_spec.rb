require 'spec_helper'
require "patches/tenant_worker"

describe Patches::TenantWorker do
  describe '#perform' do
    let(:runner) { instance_double(Patches::Runner, perform: true) }

    before do
      allow(Patches::Config.configuration).to receive(:application_version) { application_version }
    end

    context 'when application_version config is set' do
      let(:application_version) { '5828321' }

      context 'when application version matches' do
        it 'runs patches' do
          expect(subject).to receive(:run).with('test', 'path')
          subject.perform('test', 'path', 'application_version' => application_version)
        end
      end

      context 'when application_version does not match' do
        it 'does not run patches' do
          expect(subject).not_to receive(:run)
          subject.perform('test', 'path', 'application_version' => 'd8f190c')
        end

        it 'reschedules the job' do
          expect(Patches::TenantWorker).to receive(:perform_in).with(1.minute, 'test', 'path', 'application_version' => 'd8f190c')
          subject.perform('test', 'path', 'application_version' => 'd8f190c')
        end
      end
    end

    context 'when application config is not set' do
      let(:application_version) { nil }

      it 'runs patches' do
        expect(subject).to receive(:run).with('test', 'path')
        subject.perform('test', 'path', 'application_version' => 'd8f190c')
      end
    end
  end
end
