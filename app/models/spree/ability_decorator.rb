class AbilityDecorator
  include CanCan::Ability
  def initialize(user)
    can :create, Spree::ReturnAuthorization, order: { id: user.orders.ids, shipment_state: 'shipped' }
    can :read_returns_history, Spree.user_class
    can :display, Spree::ReturnAuthorization, order: { id: user.orders.ids }
  end
end

Spree::Ability.register_ability(AbilityDecorator)
