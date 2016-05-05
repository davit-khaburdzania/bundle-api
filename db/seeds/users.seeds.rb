# MARK set password to 'guest'
guest = User.create(
  name: 'Sarah Gadon',
  email: 'sarah@mail.com',
  image: 'http://i.imgur.com/XMnLzi2.jpg',
  username: 'sarah',
  about: 'Sarah Gadon was born in a quiet residential area in Toronto, Ontario, to a teacher mother and a psychologist father',
)

5.times do
  User.create(
    name: FFaker::Name.name,
    email: FFaker::Internet.email,
    username: FFaker::Internet.user_name,
    image: FFaker::Avatar.image,
    auth_token: JWT.encode(FFaker::Internet.email, DateTime.now.to_s)
  )
end
