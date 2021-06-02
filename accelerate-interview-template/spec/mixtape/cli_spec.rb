# frozen_string_literal: true

require 'json'
require 'tempfile'
require 'mixtape/cli'

RSpec.describe Mixtape::CLI do
  describe '.add_playlist' do
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
        playlists: [{ id: '1', owner_id: '1', song_ids: ['1'] }]
      }
    end

    def json_tempfile(basename)
      Tempfile.new([basename, '.json']).tap { |file| file.sync = true }
    end

    let(:input_file) { json_tempfile('input') }
    let(:changes_file) { json_tempfile('changes') }
    let(:output_file) { json_tempfile('output') }
    let(:files) { [input_file, changes_file, output_file] }

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

    it 'adds the playlist' do
      
      described_class.apply_changes(files.map(&:path))

      expect(described_class.read_json(output_file)).to eq(output)
    end
  end
  describe '.remove_playlist' do
    let(:input) do
      {
        users: [{ id: '1', name: 'Albin Jaye' }],
        playlists: [{ id: '1', owner_id: '1', song_ids: ['1'] }, { id: '2', user_id: '1', song_ids: ['1'] }],
        songs: [
          { id: '1', artist: 'Camila Cabello', title: 'Never Be the Same' }
        ]
      }
    end
    let(:input2) do
      {
        users: [{ id: '1', name: 'Albin Jaye' }],
        playlists: [{ id: '1', owner_id: '1', song_ids: ['1'] }],
        songs: [
          { id: '1', artist: 'Camila Cabello', title: 'Never Be the Same' }
        ]
      }
    end
    let(:changes) { [{ type: 'remove_playlist', playlist_id: '2'}] }
    let(:output) do
      {
        users: [{ id: '1', name: 'Albin Jaye' }],
        playlists: [{ id: '1', owner_id: '1', song_ids: ['1'] }],
        songs: [
          { id: '1', artist: 'Camila Cabello', title: 'Never Be the Same' }
        ]
      }
    end

    def json_tempfile(basename)
      Tempfile.new([basename, '.json']).tap { |file| file.sync = true }
    end

    let(:input_file) { json_tempfile('input') }
    let(:input_file2) { json_tempfile('input2') }
    let(:changes_file) { json_tempfile('changes') }
    let(:output_file) { json_tempfile('output') }
    let(:files) { [input_file, changes_file, output_file] }
    let(:files2) { [input_file2, changes_file, output_file] }

    before do
      input_file.write(input.to_json)
      input_file2.write(input2.to_json)
      changes_file.write(changes.to_json)
    end

    after do
      files.each do |file|
        file.close
        file.unlink
      end
      files2.each do |file|
        file.close
        file.unlink
      end
    end

    it 'removes a playlist' do
      
      described_class.apply_changes(files.map(&:path))

      expect(described_class.read_json(output_file)).to eq(output)
    end

    it 'raises exception if playlist does not exist' do
      expect do
        described_class.apply_changes(files2.map(&:path))
      end.to raise_error("playlist does not exist")
    end
  end
  describe '.add_song_to_playlist' do
    let(:input) do
      {
        users: [{ id: '1', name: 'Albin Jaye' }],
        playlists: [{ id: '1', owner_id: '1', song_ids: ['1'] }],
        songs: [
          { id: '1', artist: 'Camila Cabello', title: 'Never Be the Same' }, { "id": "2",
            "artist": "Zedd", "title": "The Middle" },
        ]
      }
    end
    let(:changes) { [{ type: 'add_song_to_playlist', playlist_id: '1', song_id: '2'}] }
    let(:changes2) { [{ type: 'add_song_to_playlist', playlist_id: '3', song_id: '2'}] }
    let(:changes3) { [{ type: 'add_song_to_playlist', playlist_id: '1', song_id: '3'}] }
    let(:changes4) { [{ type: 'add_song_to_playlist', playlist_id: '1', song_id: '1'}] }
    let(:output) do
      {
        users: [{ id: '1', name: 'Albin Jaye' }],
        playlists: [{ id: '1', owner_id: '1', song_ids: ['1', '2'] }],
        songs: [
          { id: '1', artist: 'Camila Cabello', title: 'Never Be the Same' }, { "id": "2",
            "artist": "Zedd", "title": "The Middle" },
        ]
      }
    end

    def json_tempfile(basename)
      Tempfile.new([basename, '.json']).tap { |file| file.sync = true }
    end

    let(:input_file) { json_tempfile('input') }
    let(:changes_file) { json_tempfile('changes') }
    let(:changes_file2) { json_tempfile('changes2') }
    let(:changes_file3) { json_tempfile('changes3') }
    let(:changes_file4) { json_tempfile('changes4') }
    let(:output_file) { json_tempfile('output') }
    let(:files) { [input_file, changes_file, output_file] }
    let(:files2) { [input_file, changes_file2, output_file] }
    let(:files3) { [input_file, changes_file3, output_file] }
    let(:files4) { [input_file, changes_file4, output_file] }

    before do
      input_file.write(input.to_json)
      changes_file.write(changes.to_json)
      changes_file2.write(changes2.to_json)
      changes_file3.write(changes3.to_json)
      changes_file4.write(changes4.to_json)
    end

    after do
      files.each do |file|
        file.close
        file.unlink
      end
      files2.each do |file|
        file.close
        file.unlink
      end
      files3.each do |file|
        file.close
        file.unlink
      end
      files4.each do |file|
        file.close
        file.unlink
      end
    end

    it 'adds a song to the playlist' do
      
      described_class.apply_changes(files.map(&:path))

      expect(described_class.read_json(output_file)).to eq(output)
    end

    it 'raises exception if playlist does not exist' do
      expect do
        described_class.apply_changes(files2.map(&:path))
      end.to raise_error("playlist does not exist")
    end
    it 'raises exception if song does not exist' do
      expect do
        described_class.apply_changes(files3.map(&:path))
      end.to raise_error("song does not exist")
    end
    it 'raises exception if song already added to playlist' do
      expect do
        described_class.apply_changes(files4.map(&:path))
      end.to raise_error("song already added to playlist")
    end
  end
  describe '.test_all' do
    let(:input) do
      JSON.parse(File.read('example/mixtape.json'))
    end
    let(:changes) do
      JSON.parse(File.read('example/changes.json'))
    end
    let(:output) do
      JSON.parse(File.read('example/output.json'), :symbolize_names => true)
    end

    def json_tempfile(basename)
      Tempfile.new([basename, '.json']).tap { |file| file.sync = true }
    end

    let(:input_file) { json_tempfile('input') }
    let(:changes_file) { json_tempfile('changes') }
    let(:output_file) { json_tempfile('output') }
    let(:files) { [input_file, changes_file, output_file] }

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

    it 'applies all changes' do
      described_class.apply_changes(files.map(&:path))

      expect(described_class.read_json(output_file)).to eq(output)
    end
  end
end
