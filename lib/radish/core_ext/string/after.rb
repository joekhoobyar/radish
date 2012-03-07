''.freeze.tap do |k|

	::String.class_eval do
		def after(str,dlm=nil)
			return if length < str.length or str != self[0, str.length]
			if dlm.nil?
				self[str.length, length]
			elsif dlm.length <= length - str.length and dlm == self[str.length, dlm.length]
				self[str.length + dlm.length, length]
			else
				k
			end
		end
	end

end
