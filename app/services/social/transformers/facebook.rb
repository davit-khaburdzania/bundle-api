class Social::Transformers::Facebook
  def initialize(data)
    @data = data
    @provider = 'facebook'
  end

  def data
    {
      uid: @data[:uid],
      name: @data[:info][:name],
      email: @data[:info][:email],
      image: @data[:info][:image],
      provider: @provider
    }
  end
end
