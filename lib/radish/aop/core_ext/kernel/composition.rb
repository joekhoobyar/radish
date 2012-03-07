# composing a pointcut on most things has to check for a metaclass.
module Kernel
  def compose! points, advice=nil
    unless metaclass? then not_implemented else
      self.class.compose! points, advice
    end
  end
  def pure?; false end
end
