module ROCrate
  ##
  # A Ruby abstraction of an RO Crate.
  class Crate < Directory
    attr_reader :data_entities
    attr_reader :contextual_entities
    properties(%w[name datePublished author license identifier distribution contactPoint publisher description url hasPart])

    def initialize
      @data_entities = []
      @contextual_entities = []
      super(self, './')
    end

    def add_file(path_or_io, entity_class: ROCrate::File, **properties)
      path = properties.delete(:path)
      path_or_io = ::File.open(path_or_io) if path_or_io.is_a?(String)
      path ||= path_or_io.respond_to?(:path) ? ::File.basename(path_or_io.path) : nil
      entity_class.new(self, path_or_io, path, properties).tap { |e| add_data_entity(e) }
    end

    def add_directory(path_or_file, entity_class: ROCrate::Dataset, **properties)
      raise 'Not a directory' if path_or_file.is_a?(::File) && !::File.directory?(path_or_file)
      path_or_file ||= path_or_file.respond_to?(:path) ? path_or_file.path : path_or_file
      entity_class.new(self, path_or_file, properties).tap { |e| add_data_entity(e) }
    end

    def add_person(id, properties = {})
      create_contextual_entity(id, properties, entity_class: ROCrate::Person)
    end

    def add_contact_point(id, properties = {})
      create_contextual_entity(id, properties, entity_class: ROCrate::ContactPoint)
    end

    def add_organization(id, properties = {})
      create_contextual_entity(id, properties, entity_class: ROCrate::Organization)
    end

    def create_contextual_entity(id, properties, entity_class: nil)
      entity = (entity_class || ROCrate::Entity).new(self, id, properties)
      entity = entity.specialize if entity_class.nil?
      add_contextual_entity(entity)
      entity
    end

    def add_contextual_entity(entity)
      entity = claim(entity)
      contextual_entities.delete(entity) # Remove (then re-add) the entity if it exists
      contextual_entities.push(entity)
      entity
    end

    def add_data_entity(entity)
      entity = claim(entity)
      data_entities.delete(entity) # Remove (then re-add) the entity if it exists
      data_entities.push(entity)
      entity
    end

    def metadata
      @metadata ||= ROCrate::Metadata.new(self)
    end

    def entities
      default_entities | data_entities | contextual_entities
    end

    def default_entities
      [metadata, self]
    end

    def properties
      super.merge('hasPart' => data_entities.map(&:reference))
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def resolve_id(*parts)
      URI.join("arcp://uuid,#{uuid}", *parts)
    end

    ##
    # Copy the entity, but as if it was in this crate.
    # (Or just return the entity if it was already included)
    def claim(entity)
      return entity if entity.crate == self
      entity.class.new(crate, entity.id, entity.raw_properties)
    end
  end
end
