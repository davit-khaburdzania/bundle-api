User.all.each do |u|
  AuthProvider.create(
    user: u,
    uid: (rand(10000).to_s + u.id.to_s).to_i,
    provider: ['facebook', 'twitter'].sample
  )
end
