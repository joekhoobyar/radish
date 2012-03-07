# composing an aspect from a pointcut as an Enumerable.
module Enumerable
  def weave advice
    inject(advice) { |state, point| point.weave state }
  end
  def weave! advice
    replace( inject(advice) { |state, point| point.weave! state } )
  end
end
