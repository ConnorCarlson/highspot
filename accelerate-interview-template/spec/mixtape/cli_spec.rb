# frozen_string_literal: true

require 'json'
require 'tempfile'
require 'mixtape/cli'

RSpec.describe Mixtape::CLI do
  describe '.apply_changes' do
    let(:input) do
      {
        users: [{ id: '1', name: 'Albin Jaye' }],
        playlists: [],
        songs: [
          { id: '1', artist: 'Camila Cabello', title: 'Never Be the Same' }
        ]
      }
    end
    let(:changes) { [{ type: 'add_playlist', user_id: '1', song_ids: ['1'] }] }
    let(:output) do
      {
        **input,
        playlists: [{ id: '1', user_id: '1', song_ids: ['1'] }]
      }
    end

    def json_tempfile(basename)
      Tempfile.new([basename, '.json']).tap { |file| file.sync = true }
    end

    let(:input_file) { json_tempfile('input') }
    let(:changes_file) { json_tempfile('changes') }
    let(:output_file) { json_tempfile('output') }
    let(:files) { [input_file, changes_file, output_file] }

    let!(:mixtape_class) do
      class_double('Mixtape').as_stubbed_const(transfer_nested_constants: true)
    end

    before do
      input_file.write(input.to_json)
      changes_file.write(changes.to_json)
    end

    after do
      files.each do |file|
        file.close
        file.unlink
      end
    end

    it 'raises an error when too few args are given' do
      expect do
        described_class.apply_changes([])
      end.to raise_error(described_class::Error, /got 0/)
    end

    it 'raises an error when too many args are given' do
      expect do
        described_class.apply_changes(%w[too many paths given])
      end.to raise_error(described_class::Error, /got 4/)
    end

    it 'writes changes to the output' do
      allow(mixtape_class).to receive(:apply_changes)
        .with(input, changes)
        .and_return(output)

      described_class.apply_changes(files.map(&:path))

      expect(described_class.read_json(output_file)).to eq(output)
    end
  end
end
