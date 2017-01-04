require "spec_helper"

describe Spree::Product do
  let(:product) { create(:base_product, returnable: true) }

  describe 'validations' do
    subject { product }
    it { is_expected.to validate_numericality_of(:return_time).is_greater_than_or_equal_to(0) }
  end

  describe 'scopes' do
    describe '.returnable' do
      let!(:returnable_product) { create(:product, returnable: true) }
      let!(:non_returnable_product) { create(:product) }

      subject { Spree::Product.returnable }

      it { is_expected.to include(returnable_product) }
      it { is_expected.to_not include(non_returnable_product) }
    end
  end

end
