require 'uri'
require 'securerandom'
require 'json'
require 'zip'
require 'zip/filesystem'
require 'addressable'
require_relative './ro_crate/json_ld_hash'
require_relative './ro_crate/model/entity'
require_relative './ro_crate/model/data_entity'
require_relative './ro_crate/model/file'
require_relative './ro_crate/model/entry'
require_relative './ro_crate/model/directory'
require_relative './ro_crate/model/metadata'
require_relative './ro_crate/model/preview'
require_relative './ro_crate/model/crate'
require_relative './ro_crate/model/contextual_entity'
require_relative './ro_crate/model/person'
require_relative './ro_crate/model/contact_point'
require_relative './ro_crate/model/organization'
require_relative './ro_crate/reader'
require_relative './ro_crate/writer'

module ROCrateRuby
end

# ctx = JSON::LD::Context.parse(::File.join(::File.dirname(__FILE__), '..', 'vendor', 'ro-crate-context-0-2.json'))
# JSON::LD::Context.add_preloaded('https://w3id.org/ro/crate/0.2/context', ctx)
