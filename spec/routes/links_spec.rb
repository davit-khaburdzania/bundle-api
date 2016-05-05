require 'rails_helper'

describe LinksController, type: :routing do
  it 'should route to #show' do
    expect(get '/links/1').to route_to('links#show', id: '1')
  end

  it 'should route to #create' do
    expect(post '/links').to route_to('links#create')
  end

  it 'should route to #update' do
    expect(put '/links/1').to route_to('links#update', id: '1')
  end

  it 'should route to #destroy' do
    expect(delete '/links/1').to route_to('links#destroy', id: '1')
  end
end
