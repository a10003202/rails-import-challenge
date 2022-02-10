json.set! :data do
  json.array! @users do |admin_user|
    json.partial! 'admin_users/admin_user', user: admin_user
    json.url  "
              #{link_to 'Show', admin_user }
              #{link_to 'Edit', edit_admin_user_path(admin_user)}
              #{link_to 'Destroy', admin_user, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end