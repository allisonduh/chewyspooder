class Product < ApplicationRecord

	def self.search(searchyes,searchno)
		return self unless searchyes.present? || searchno.present?
			yes_split = searchyes.split('[, ;]').map{|w| "ingredients LIKE ? "}.join(" OR ")  
  			where(['ingredients ILIKE ? AND ingredients NOT ILIKE ?', "%#{yes_split}%", "%#{searchno}%"])
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