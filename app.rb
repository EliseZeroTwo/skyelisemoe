require 'json'
require 'net/http'
require './secrets'
require 'sinatra'

set :static, true

def getHypixelPlayer(playerName)
    JSON.parse(Net::HTTP.get(URI("https://api.hypixel.net/player?key=#{API_KEY}&name=#{playerName}")))
end

def getProfilesByPlayerName(playerName)
    player = getHypixelPlayer(playerName)
    return nil if player.nil?
    outArr = []
    player['player']['stats']['SkyBlock']['profiles'].each { |key, val| outArr.push([val['cute_name'], val['profile_id']]) }
    outArr
end

get '/stats/:user' do
    profiles = getProfilesByPlayerName(params['user'])
    return 'no profiles' if profiles.empty?
    redirect "/stats/#{params['user']}/#{profiles[-1][0]}"
end

get '/stats/:user/' do
    profiles = getProfilesByPlayerName(params['user'])
    return 'no profiles' if profiles.empty?
    redirect "/stats/#{params['user']}/#{profiles[-1][0]}"
end

get '/stats/:user/:profile' do
    erb :profile
end
