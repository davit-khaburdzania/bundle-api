after :users do
  User.all.each do |user|
    4.times do
      name = rand(2..5).times.map { FFaker::Lorem.word }.join(' ')
      Collection.create(creator: user, name: name)
    end
  end
end
