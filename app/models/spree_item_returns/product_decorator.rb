module SpreeItemReturns::ProductDecorator

  def self.prepended(base)
    base.validates :return_time, numericality: { greater_than_or_equal_to: 0 }
    base.scope :returnable, -> { where(returnable: true) }
  end
end

Spree::Product.prepend SpreeItemReturns::ProductDecorator
