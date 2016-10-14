require "spec_helper"

describe Spree::User do
  describe 'associations' do
    it { is_expected.to have_many(:return_authorizations).through(:orders) }
  end
end
