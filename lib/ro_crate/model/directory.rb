module ROCrate
  ##
  # A data entity that represents a directory of potentially many files and subdirectories (or none).
  class Directory < DataEntity
    attr_accessor :content
    properties(%w[name contentSize dateModified encodingFormat identifier sameAs])

    def self.format_id(id)
      super + '/'
    end

    def initialize(crate, input_directory = nil, crate_path = nil, properties = {})
      raise 'Not a directory' if input_directory && !(::File.directory?(input_directory) rescue false)
      super(crate, crate_path, properties)
      @entries = {}
      if input_directory
        Dir.chdir(input_directory) { Dir.glob("**/*") }.each do |file|
          source_path = Pathname.new(::File.join(input_directory, file)).expand_path
          dest_path = ::File.join(filepath, file)
          @entries[dest_path] = Entry.new(source_path)
        end
      end
    end

    def entries
      @entries
    end

    private

    def default_properties
      super.merge(
        '@id' => "#{SecureRandom.uuid}/",
        '@type' => 'Dataset'
      )
    end
  end
end
