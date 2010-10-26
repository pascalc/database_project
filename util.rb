module Util
	def Util::rand_from_arrays(length = 5, *arrays)
		options = arrays.inject do |x,y| 
			x = x.to_a unless x.is_a? Array
	      		y = y.to_a unless y.is_a? Array

			x + y		
		end
		res = ""
		length.times { res << options[rand(options.size)] }
		return res
	end

	def Util::random_string(length = 5)
		Util::rand_from_arrays(length,("A".."Z"),("a".."z"),("0".."9"))
	end

	def Util::random_number(length = 4)
		Util::rand_from_arrays(length,("0".."9"))
	end
end
