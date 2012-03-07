class Radish::Vector < Array

	def hash
		inject(0) {|n,v| n*65599 + v.hash }
	end

end
