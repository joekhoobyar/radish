require 'radish/core_ext/object/metaclass'
require 'radish/core_ext/is_metaclass'
require 'radish/vector'

require 'facets/binding'
require 'facets/kernel'
require 'facets/proc'
require 'facets/symbol'

module Radish
	module AOP

		require 'radish/aop/core_ext/symbol/normalize'
		require 'radish/aop/core_ext/symbol/table'
		require 'radish/aop/core_ext/module/enumerate'
		require 'radish/aop/core_ext/module/implements'
		require 'radish/aop/core_ext/enumerable/composition'
		require 'radish/aop/core_ext/kernel/composition'
		require 'radish/aop/core_ext/module/composition'
				
		require 'radish/aop/joinpoint'
		require 'radish/aop/callable'
		require 'radish/aop/pointcut'
		require 'radish/aop/core_ext/unbound_method/glue'
		require 'radish/aop/core_ext/method/glue'
		require 'radish/aop/core_ext/proc/glue'
		require 'radish/aop/core_ext/symbol/glue'
		require 'radish/aop/core_ext/array/glue'

		require 'radish/aop/domain'
		require 'radish/aop/advice'
		require 'radish/aop/cuttable'
		require 'radish/aop/aspect'

	end
end
