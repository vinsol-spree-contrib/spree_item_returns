require "spec_helper"

describe Spree::ReturnAuthorization do

  describe 'scopes' do
    describe '.returnable' do
      let!(:returnable_product) { create(:product) }
      let!(:non_returnable_product) { create(:product, returnable: false) }

      subject { Spree::Product.returnable }

      it { is_expected.to include(returnable_product) }
      it { is_expected.to_not include(non_returnable_product) }
    end
  end

end
