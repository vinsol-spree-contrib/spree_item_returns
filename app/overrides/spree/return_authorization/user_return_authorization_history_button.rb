Deface::Override.new(
  virtual_path: 'spree/users/show',
  name: 'user_return_authorization_history_button',
  insert_bottom: "[data-hook='account_my_orders'] h3",
  text: "<%= link_to(spree.return_authorizations_path, class: 'btn btn-primary pull-right') do %>
          <span class='glyphicon glyphicon-list-alt'></span>
          <%= Spree.t(:returns_history) %>
        <% end %>"
)
