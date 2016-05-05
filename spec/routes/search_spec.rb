require 'rails_helper'

describe SearchController, type: :routing do
  it 'should route to #resource' do
    expect(get '/search/resource').to route_to('search#resource')
  end
end
