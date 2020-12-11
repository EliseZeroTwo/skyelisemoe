#!/usr/bin/env ruby

require 'erubis'
require 'json'
require './leveling'
require 'net/http'
require './secrets'
require 'sinatra'
require 'time'

set :erb, :escape_html => true

set :bind, '0.0.0.0'
set :port, 80
set :static, true

def getUUIDFromName(playerName)
    jsonRes = JSON.parse(Net::HTTP.get(URI("https://api.mojang.com/users/profiles/minecraft/#{playerName}?at=#{Time.now.to_i}")))
    jsonRes.include?('id') ? jsonRes['id'] : nil
end

def getHypixelPlayer(playerName)
    JSON.parse(Net::HTTP.get(URI("https://api.hypixel.net/player?key=#{API_KEY}&name=#{playerName}")))
end

def getProfilesByPlayerName(playerName)
    player = getHypixelPlayer(playerName)
    outArr = []
    player['player']['stats']['SkyBlock']['profiles'].each { |key, val| outArr.push([val['cute_name'], val['profile_id']]) } unless player['player'].nil? || player['player']['stats']['SkyBlock'].nil?
    outArr
end

def getSkyblockProfile(playerUUID, profileUUID)
    jsonRes = JSON.parse(Net::HTTP.get(URI("https://api.hypixel.net/skyblock/profiles?key=#{API_KEY}&uuid=#{playerUUID}")))
    return nil if jsonRes['profiles'].nil?
    outProfile = nil
    jsonRes['profiles'].each { |profile| outProfile = profile['members'][playerUUID] if profile['profile_id'] == profileUUID }
    outProfile
end

get '/:user' do
    profiles = getProfilesByPlayerName(params['user'])
    return 'no profiles' if profiles.empty?
    redirect "/stats/#{params['user']}/#{profiles[-1][0]}"
end

get '/:user/:profile' do
    redirect "/stats/#{params['user']}/#{params['profile']}"
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
    p 'req starting'
    @username = params['user']
    @profiles = getProfilesByPlayerName(params['user'])
    @profile = nil
    @profiles.each { |x| @profile = x[1] if x.include?(params['profile']) }
    @playerUUID = getUUIDFromName(params['user'])
    return 'user not found' if @playerUUID.nil?
    profile = getSkyblockProfile(@playerUUID, @profile)
    @fairySoulCount = profile['fairy_souls_collected']
    p 'req finished'

    @skills = {}
    maxSkills = getUserSkillcap(profile)
    eachSkill do |skill|
        next unless profile.include? "experience_skill_#{skill}"
        @skills[skill] = getLevelByXp(profile["experience_skill_#{skill}"], skill, maxSkills)
    end

    erb :profile
end

not_found do
   erb :index
end
