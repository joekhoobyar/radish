# composing an pointcut from advice and joinpoints across a Module.
class Module
  def compose points, advice=nil
    pointcut = Array.new ; points.each do |point|
      join_point = yield(point) or return
      pointcut << join_point.weave(advice)
    end ; pointcut
  end

  def compose!(points, advice=nil) not_implemented end
end
