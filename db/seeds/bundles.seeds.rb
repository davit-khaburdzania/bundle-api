after :collections do
  Collection.all.each do |collection|
    rand(4..6).times do
      name = rand(2..5).times.map { FFaker::Lorem.word }.join(' ')

      Bundle.create(
        collection: collection,
        creator: collection.creator,
        name: name,
        description: FFaker::Lorem.sentence,
      )
    end
  end
end
