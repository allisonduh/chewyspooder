class Product < ApplicationRecord

	def self.search(wantstr,nowantstr)
		if wantstr || nowantstr
			self.primary_key
			
			splitstr  = wantstr.split(/\s*,\s*/)
			.map { |s| s.gsub(/[_%]/, '%' => '\\%', '_' => '\\_') }
			.map { |s| '%' + s + '%' }
			splitstr_excl  = nowantstr.split(/\s*,\s*/)
			.map { |s| s.gsub(/[_%]/, '%' => '\\%', '_' => '\\_') }
			.map { |s| '%' + s + '%' }
			if wantstr
				incl_results = Product.where('ingredients ILIKE all(array[?])', splitstr)
			else
				incl_results = Product.where('ingredients ILIKE all(array[?])', splitstr_excl)
			end
			if wantstr.length>1 && nowantstr.length>1
				results=Product.where.not('ingredients ILIKE all(array[?])', splitstr_excl)
				if results
					results=incl_results.where.not('ingredients ILIKE all(array[?])', splitstr_excl)
				else
					self.all
				end
			else
				results=incl_results
			end
			#findbool=Product.where('ingredients ILIKE ?', '%'+want+ '%')
			
		else
			self.all
		end
	end

	def self.searchyes(wantstr)
		if wantstr
			self.primary_key
			
			splitstr  = wantstr.split(/\s*,\s*/)
			.map { |s| s.gsub(/[_%]/, '%' => '\\%', '_' => '\\_') }
			.map { |s| '%' + s + '%' }
			findbool = Product.where('ingredients ILIKE all(array[?])', splitstr)
			#findbool=Product.where('ingredients ILIKE ?', '%'+want+ '%')
			if findbool
				findbool
			else
				self.all
			end
		else
			self.all
		end
	end

	def self.searchno(wantno)
		if wantno
			self.primary_key

			findbool=Product.where.not('ingredients ILIKE ?', '%'+wantno+ '%')
			if findbool
				Product.where.not('ingredients ILIKE ?', '%'+wantno + '%')
			else
				self.all
			end
		else
			self.all
		end
	end

end