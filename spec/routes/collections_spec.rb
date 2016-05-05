require 'rails_helper'

describe CollectionsController, type: :routing do
  it 'should route to #index' do
    expect(get '/collections').to route_to('collections#index')
  end

  it 'should route to #show' do
    expect(get '/collections/1').to route_to('collections#show', id: '1')
  end

  it 'should route to #create' do
    expect(post '/collections').to route_to('collections#create')
  end

  it 'should route to #update' do
    expect(put '/collections/1').to route_to('collections#update', id: '1')
  end

  it 'should route to #destroy' do
    expect(delete '/collections/1').to route_to('collections#destroy', id: '1')
  end

  it 'should route to #bundles' do
    expect(get '/collections/1/bundles').to route_to('collections#bundles', id: '1')
  end
end
