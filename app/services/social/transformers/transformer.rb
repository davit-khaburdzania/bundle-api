class Social::Transformers::Transformer
  attr_reader :transformer

  CLASS_PREFIX = 'Social::Transformers::'

  def initialize(params)
    @params = params
    @provider = params[:provider]
    @data = params[:data]
    @transformer = transformer_class_name.constantize.new(@data)
  end

  def data
    @transformer.data
  end

private

  def transformer_class_name
    CLASS_PREFIX + @provider.capitalize
  end
end
