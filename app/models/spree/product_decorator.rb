Spree::Product.class_eval do

  validates :return_time, numericality: { greater_than_or_equal_to: 0 }

  scope :returnable, -> { where(returnable: true) }

end
