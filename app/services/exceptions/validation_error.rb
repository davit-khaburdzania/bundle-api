class Exceptions::ValidationError < StandardError
  def initialize(errors)
    @errors = errors
  end

  def error_message
    'Validation failed: see details'
  end

  def errors
    @errors
  end
end
