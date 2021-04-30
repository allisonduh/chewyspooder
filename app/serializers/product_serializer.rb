class ProductSerializer < ActiveModel::Serializer
	attributes :ingredients, :url, :caloriespercan
end
