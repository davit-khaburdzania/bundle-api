class Social::Api::Client
  attr_reader :client

  CLASS_PREFIX = 'Social::Api::'

  def initialize(params)
    @params = params
    @provider = params[:provider]
    @client = client_class_name.constantize.new(@params)
  end

  def data
    @client.data
  end

private

  def client_class_name
    CLASS_PREFIX + @provider.capitalize
  end
end
