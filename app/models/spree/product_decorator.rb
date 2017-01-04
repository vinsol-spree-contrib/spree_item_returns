Spree::Product.class_eval do

  scope :returnable, -> { where(returnable: true) }

end
