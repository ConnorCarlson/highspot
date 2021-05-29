# frozen_string_literal: true

require 'json'
require 'mixtape'

module Mixtape
  class CLI
    class Error < StandardError; end

    def self.apply_changes(argv)
      unless argv.length == 3
        raise Error, <<~USAGE
          Expected 3 arguments, got #{argv.length}

          Usage: mixtape INPUT_FILENAME CHANGES_FILENAME OUTPUT_FILENAME
        USAGE
      end

      mixtape_filename, changes_filename, output_filename = argv

      mixtape = read_json(mixtape_filename)
      changes = read_json(changes_filename)

      output = Mixtape.apply_changes(mixtape, changes)

      File.open(output_filename, 'w') do |f|
        f.write(JSON.pretty_generate(output))
      end
    end

    def self.read_json(filename)
      JSON.parse(File.read(filename), symbolize_names: true)
    end
  end
end
