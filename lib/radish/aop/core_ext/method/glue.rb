# composing an aspect from method advice.
class Method
  include Callable
  include Pointcut
end
