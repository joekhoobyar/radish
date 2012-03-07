module Radish; end

require 'radish/core_ext/object'
require 'facets/typecast'
require 'orderedhash'
require 'facets/dictionary'

require 'radish/core_ext/typecast'
require 'radish/core_ext/module'
require 'radish/core_ext/array'
require 'radish/core_ext/hash'
require 'radish/core_ext/set'
require 'radish/core_ext/string'
require 'radish/core_ext/inflector'
require 'radish/core_ext/time'

require 'radish/loose_types'
require 'radish/set_with_indifferent_access'
require 'radish/method_info'
require 'radish/accessors'
require 'radish/enums_and_bitsets'
require 'radish/vector'
require 'radish/uri'
require 'radish/open_struct'
require 'radish/weak_keyed_cache'
require 'radish/attr_marshal'

require 'radish/xml_providers/libxml_adapter'

if defined? ActiveRecord::Base
  require 'radish/core_ext/active_record/errors'
	require 'radish/core_ext/active_record/exists'
	require 'radish/core_ext/active_record/associations/avoid_loading'
	require 'radish/core_ext/active_record/associations/include'
	require 'radish/core_ext/active_record/associations/create'
	require 'radish/core_ext/active_record/transaction'
	require 'radish/core_ext/active_record/model_marshal'
end

if defined? ActionController::Base
  require 'radish/core_ext/action_controller/request_parameters'
end
