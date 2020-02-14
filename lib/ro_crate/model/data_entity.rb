module ROCrate
  ##
  # A class to represent a "Data Entity" within an RO Crate.
  # Data Entities are the actual physical files and directories within the Crate.
  class DataEntity < Entity
    def self.format_id(id)
      super.chomp('/')
    end

    def entries
      {}
    end

    ##
    # A disk-safe filepath based on the ID of this DataEntity.
    #
    # @return [String] The relative file path of this DataEntity within the Crate.
    def filepath
      Addressable::URI.unescape(id.sub(/\A\//, '')).to_s # Remove initial / and decode %20 etc.
    end
  end
end
