require 'fileutils'

module Pupa
  class Processor
    class DocumentStore
      # Stores JSON documents on disk.
      #
      # @see ActiveSupport::Cache::FileStore
      class FileStore
        # @param [String] output_dir the directory in which to dump JSON documents
        def initialize(output_dir)
          @output_dir = output_dir
          FileUtils.mkdir_p(@output_dir)
        end

        # Returns whether a file with the given name exists.
        #
        # @param [String] name a key
        # @return [Boolean] whether the store contains an entry for the given key
        def exist?(name)
          File.exist?(path(name))
        end

        # Returns all file names in the storage directory.
        #
        # @return [Array<String>] all keys in the store
        def entries
          Dir.chdir(@output_dir) do
            Dir['*.json']
          end
        end

        # Returns, as JSON, the contents of the file with the given name.
        #
        # @param [String] name a key
        # @return [Hash] the value of the given key
        def read(name)
          File.open(path(name)) do |f|
            Oj.load(f)
          end
        end

        # Returns, as JSON, the contents of the files with the given names.
        #
        # @param [String] names keys
        # @return [Array<Hash>] the values of the given keys
        def read_multi(names)
          names.map do |name|
            read(name)
          end
        end

        # Writes, as JSON, the value to a file with the given name.
        #
        # @param [String] name a key
        # @param [Hash] value a value
        def write(name, value)
          File.open(path(name), 'w') do |f|
            f.write(Oj.dump(value, mode: :compat, time_format: :ruby))
          end
        end

        # Writes, as JSON, the value to a file with the given name, unless such
        # a file exists.
        #
        # @param [String] name a key
        # @param [Hash] value a value
        # @return [Boolean] whether the key was set
        def write_unless_exists(name, value)
          !exist?(name).tap do |exists|
            write(name, value) unless exists
          end
        end

        # Writes, as JSON, the values to files with the given names.
        #
        # @param [Hash] pairs key-value pairs
        def write_multi(pairs)
          pairs.each do |name,value|
            write(name, value)
          end
        end

        # Delete a file with the given name.
        #
        # @param [String] name a key
        def delete(name)
          File.delete(path(name))
        end

        # Deletes all files in the storage directory.
        def clear
          Dir[File.join(@output_dir, '*.json')].each do |path|
            File.delete(path)
          end
        end

        # Collects commands to run all at once.
        def pipelined
          yield
        end

        # Returns the path to the file with the given name.
        #
        # @param [String] name a key
        # @param [String] a path
        def path(name)
          File.join(@output_dir, name)
        end
      end
    end
  end
end
