Deface::Override.new(
  virtual_path: 'spree/users/show',
  name: 'user_return_authorization_history_button',
  insert_bottom: "[data-hook='account_my_orders'] h3",
  text: "<%= link_to(spree.return_authorizations_path, class: 'btn btn-primary float-right') do %>
          <span class='glyphicon glyphicon-list-alt'><%= icon(name: 'burger', classes: 'd-none d-xl-inline-block', width: 20, height: 20)  %></span>
          <%= Spree.t(:returns_history) %>
        <% end %>"
)
