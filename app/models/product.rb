class Product < ApplicationRecord
	scope :filter_by_ingredient, -> (ingredient) {where ingredients: ingredients}
	def self.search_ingredients(wantstr,nowantstr)
		if wantstr || nowantstr
			splitstr  = wantstr.downcase.split(/\s*,\s*/)
			.map { |s| s.gsub(/[_%]/, '%' => '\\%', '_' => '\\_') }
			.map { |s| '%' + s + '%' }
			splitstr_excl  = nowantstr.downcase.split(/\s*,\s*/)
			.map { |s| s.gsub(/[_%]/, '%' => '\\%', '_' => '\\_') }
			.map { |s| '%' + s + '%' }
			puts"test1"	
			puts splitstr.length
			puts"test2"
			puts splitstr_excl.length
			if splitstr.length>=1 && splitstr_excl.length>=1
				incl_results = Product.where('ingredients ILIKE all(array[?])', splitstr)
				results=incl_results.where.not('ingredients ILIKE all(array[?])', splitstr_excl)
			elsif splitstr.length>=1
				results = Product.where('ingredients ILIKE all(array[?])', splitstr)
			elsif splitstr_excl.length>=1
				incl_results = Product.where.not('ingredients ILIKE all(array[?])', splitstr_excl)
				incl_results
			else
				self.all
			end
			#findbool=Product.where('ingredients ILIKE ?', '%'+want+ '%')
			
			#findbool=Product.where('ingredients ILIKE ?', '%'+want+ '%')
		else
			self.all
		end
	end

end