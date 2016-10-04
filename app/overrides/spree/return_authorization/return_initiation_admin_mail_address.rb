Deface::Override.new(
  virtual_path: 'spree/admin/general_settings/edit',
  name: 'return_initiation_admin_mail_address',
  insert_before: "#preferences fieldset .form-actions",
  text: %Q{
    <div class="row">
      <div class="col-md-6">
        <div class="form-group" data-hook="admin_general_setting_import_mail_to_address">
          <%= label_tag :return_initiation_admin_mail_address %>
          <%= text_field_tag :return_initiation_admin_mail_address, Spree::Config[:return_initiation_admin_mail_address], placeholder: Spree.t('return_initiation_admin_mail_address.placeholder'), class: 'form-control' %>
        </div>
      </div>
    </div>
  }
)