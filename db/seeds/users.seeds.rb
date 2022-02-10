[
  {name: "Admin", email: "admin@email.com", password: "admin", roles: ["admin"]},
  {name: "User", email: "user1@email.com", password: "user", roles: ["user"]},
  {name: "User2", email: "user2@email.com", password: "user", roles: ["user"]},
  {name: "User3", email: "user3@email.com", password: "user", roles: ["user"]},
  {name: "User4", email: "user4@email.com", password: "user", roles: ["user"]},
  {name: "User5", email: "user5@email.com", password: "user", roles: ["user"]},
  {name: "User6", email: "user6@email.com", password: "user", roles: ["user"]},
  {name: "User7", email: "user7@email.com", password: "user", roles: ["user"]},
  {name: "User8", email: "user8@email.com", password: "user", roles: ["user"]},
  {name: "User9", email: "user9@email.com", password: "user", roles: ["user"]},
  {name: "User10", email: "user10@email.com", password: "user", roles: ["user"]},
  {name: "User11", email: "user11@email.com", password: "user", roles: ["user"]},
  {name: "User12", email: "user12@email.com", password: "user", roles: ["user"]},
  {name: "User13", email: "user13@email.com", password: "user", roles: ["user"]},
  {name: "User14", email: "user14@email.com", password: "user", roles: ["user"]},
].each do |user_data|
  user = User.find_by(email: user_data[:email])
  if user.nil?
    user = User.new
  end
  user.attributes = user_data.except(:roles)
  user.save!
  user_data[:roles].each do |role|
    user.add_role role
  end
end