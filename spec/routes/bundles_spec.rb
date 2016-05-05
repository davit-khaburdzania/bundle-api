require 'rails_helper'

describe BundlesController, type: :routing do
  it 'should route to #index' do
    expect(get '/bundles').to route_to('bundles#index')
  end

  it 'should route to #show' do
    expect(get '/bundles/1').to route_to('bundles#show', id: '1')
  end

  it 'should route to #create' do
    expect(post '/bundles').to route_to('bundles#create')
  end

  it 'should route to #update' do
    expect(put '/bundles/1').to route_to('bundles#update', id: '1')
  end

  it 'should route to #destroy' do
    expect(delete '/bundles/1').to route_to('bundles#destroy', id: '1')
  end
end
