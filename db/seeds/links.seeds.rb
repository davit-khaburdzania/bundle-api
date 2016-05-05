after :bundles do
  Bundle.all.each do |bundle|
    rand(4..11).times do
      title = rand(2..5).times.map { FFaker::Lorem.word }.join(' ')

      Link.create(
        bundle: bundle,
        creator: bundle.creator,
        title: title,
        description: FFaker::Lorem.sentence,
        image: FFaker::Avatar.image,
        url: FFaker::Internet.http_url
      )
    end
  end
end
