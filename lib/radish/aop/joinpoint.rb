# A join point mixin.
module JoinPoint
  not_implemented! 'advice', :weave, :weave!
  not_implemented! '', :concerning

  STATES = Hash.new{ |h,v| h[k] = v }
  SHADOWS = Hash.new{ |h,v| SYMBOLS[ s = "__aopshadow_#{v[0].to_s 36}_#{v[1..-1].join('_')}".to_sym ]; h[v] = s }

  HOOKS = lambda do |p,*a|
    s = a.pop if String===a or Symbol===a
    SHADOWS[ Radish::Vector.new(p.object_id, s, *a) ]
  end

  #def intern(*args)
  # SHADOWS[ Radish::Vector.new(object_id, *args) ]
  #end

  def transition(s, *args, &block)
    if args.empty? then self else
      join *(args.inject((@@__transition__||={})[ intern(s, *args) ] || self) & block)
    end
  end
end
