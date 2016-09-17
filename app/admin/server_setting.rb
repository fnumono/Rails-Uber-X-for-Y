ActiveAdmin.register ServerSetting do
  permit_params :price_per_hour

  menu false
  # menu :if => proc{ current_admin.email == 'superadmin@zoomerrands.com' }
end
