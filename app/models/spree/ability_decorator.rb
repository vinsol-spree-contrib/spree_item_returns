class AbilityDecorator
  ## FIXME_NISH: Please provide it a proper name like ReturnAuthorizationAbility.
  include CanCan::Ability
  def initialize(user)
    ## FIXME_NISH: Lets see if we can reduce queries here.
    can :create, Spree::ReturnAuthorization, order: { id: user.orders.ids, shipment_state: 'shipped' }
    ## FIXME_NISH: Please rename this action.
    can :read_returns_history, Spree.user_class
    can :display, Spree::ReturnAuthorization, order: { id: user.orders.ids }
  end
end

Spree::Ability.register_ability(AbilityDecorator)
