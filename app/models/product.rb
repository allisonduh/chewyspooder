class Product < ApplicationRecord

	def self.search(search)
		if search
			self.primary_key
			findbool=self.where('ingredients LIKE ?', search + '%')
			if findbool
				self.where('ingredients LIKE ?', search + '%')
			else
				self.all
			end
		else
			self.all
		end
	end

end