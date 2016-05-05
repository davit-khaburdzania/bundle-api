class Social::Api::Facebook
  def initialize(params)
    @token = params[:token]
  end

  def data
    graph = Koala::Facebook::API.new(@token)
    user_data = graph.get_object('me')
  end
end
