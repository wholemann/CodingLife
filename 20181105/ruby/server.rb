#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/cors'

require './lib/service'

set :bind, '0.0.0.0'
set :port, '32180'

set :allow_origin, '*'
set :allow_methods, 'GET,HEAD,POST'
set :allow_headers, 'content-type,if-modified-since'

service = Service.new

post '/' do
  body = request.body.read
  return if body.empty?

  data = JSON.parse(body)

  puts data.inspect

  service.call(data['method'].to_s, data['params'] || {}).merge(
    jsonrpc: '2.0',
    id: data['id']
  ).to_json
end
