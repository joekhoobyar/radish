require 'abstract'
require 'radish/aop/advice'

module Radish::AOP

	module Shadow
		SEQUENCED = lambda do |table,symbol|
			table[symbol] = "___shadow_#{table.size.to_s 36}_#{symbol}".to_sym
		end

		SYMBOLIC = lambda do |table,symbol|
			table[symbol] = "___shadow_#{table.object_id.to_s 36}_#{symbol}".to_sym
		end

		INDIRECT = lambda do |target|
			lambda { |table,symbol| table[symbol] = target.key?(symbol) ? target[symbol] : SYMBOLIC[table, symbol] }
		end
	end

	class Pointcut < Struct.new(:across, :joinpoints)

		module InstanceMethods
			def self.included(base)
				base.method_defined? :pointcut or
					base.class_eval { define_method :pointcut do Pointcut.new self.class, self end }
			end
			def collect
				block_given? and joinpoints.each { |jp| jp.pointcut }
				self
			end
		end
		
		module ExtensionMethods
			def self.extended(base)
				base.instance_variable_set(:@pointcuts, @pointcuts ||= Hash.new(&Shadow::SYMBOLIC))
			end
			def collect
				block_given? and yield(self)
				self
			end
			def pointcut
				@pointcuts[pointcut]
			end
		end

		extend ExtensionMethods
	end
	
	module Shadowing
		Shadow = ::Radish::AOP::Shadow

		def self.extended(base)
			p = base.parent.instance_variable_get(:@shadow)
			p = p ? Shadow::INDIRECT[p] : Shadow::SYMBOLIC
			base.instance_eval do
				metaclass.send :attr_accessor, :shadow
				@shadow = Hash.new &amp;p
			end
		end
	end
	
	extend Shadowing

	class JoinPoint < Struct.new(:id, :concerning)
		def shadow
			self.class.shadow[id]
		end

		def self.inherited(base)
			base.extend Shadowing
		end
	end

	class EvalJoinPoint < JoinPoint

		def initialize(id, rbsrc)
			case rbsrc
			when String
				super
			when Method, UnboundMethod, Class, IO
				super ruby_source_of(rbsrc)
			end
		end

		module WithParseTreeExtensions
		module_function

			def ruby_source_of(o)
				case rbsrc
				when String
					o
				when Method, UnboundMethod, Class, IO
					o.to_ruby
				end
			end
		end

	private
		abstract_method 'o', :ruby_source_of

	end
end

class Radish::AOP::Advice

	class Base < Struct.new(:pointcut, :body)

		abstract_method '', :arity
		abstract_method '*args', :call, :weave
		alias :[] :call

		def self.new(pointcut, body=nil, *args)
			if body.nil? and block_given?
				RubyIterator.new(pointcut, &Proc.new)
			else
				case body
				when String;         RubySource.new pointcut, body, *args
				when Proc;           RubyProc.new pointcut, body
				when Method;         RubyMethod.new pointcut, body
				when UnboundMethod;  RubyUnboundMethod.new pointcut, body
				else
					raise TypeError, body.class.name
				end
			end
		end

	private

		def signature
			@signature ||= if arity > 0 then "(#{0.upto(arity-1).map { |a| 'arg'+a.to_s }.join(', ')})" else
											"(#{0.upto(2-arity).map { |a| 'arg'+a.to_s+', ' }}*args)"
										end
		end
	end

	class RubySource < Base
		attr_reader :arity

		def initialize(pointcut, body, arity=-1, file=nil, line=nil)
			@arity = arity
		end
	end

	class RubyCallable < Base
		def initialize(pointcut, body) super end
		def arity; body.arity end
		def call(*args) body.call *args end
	end

	class RubyIterator < RubyCallable
		def initialize(pointcut, &block)
			super pointcut, block
		end
	end

	class RubyProc < RubyCallable; end

	class RubyMethod < RubyCallable; end

	class RubyUnboundMethod < RubyCallable; end

	module Production
	end

	module Transition
	end

	module Callable
	end
end

module Kernel
	include Radish::AOP::Pointcut::InstanceMethods
	def joinpoint
		JoinPoint.new to_class_sym, object_id
	end
	def pointcut
		Pointcut.new self.class, self
	end
end

class Module
	extend Radish::AOP::Pointcut::ExtensionMethods
	def self.pointcut
		self.class == Module ? self : super
	end
end

class Class
	extend Radish::AOP::Pointcut::ExtensionMethods
	def self.pointcut
		self.class == Class ? self : Pointcut.new(self.class, self)
	end
end
