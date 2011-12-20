require 'sinatra'
require 'muni'
require 'twilio-ruby'

@account_sid = ENV['SID'] || 'AC25e16e9a716a4a1786a7c83f58e30482'
@auth_token = ENV['TOKEN'] || '3d89bd57e2127b438889c6ecc78d3195'
# set up a client, without any http requests
@client = Twilio::REST::Client.new(@account_sid, @auth_token)
@account = @client.account 

get '/' do  
  r.Sms "Hi There"
  response = Twilio::TwiML::Response.new do |r|
    r.Gather :action => "input", :numDigits => 1 do
      r.Say "Hello Andrew, are you headed to Twilio, or headed home,"
      r.Say "Press 1 for Twilio,"
      r.Say "Press 2 for home"
    end
  end
  response.text
end

post '/input' do
  user_input = params[:Digits]
  
  if user_input == "1"
    bus = Muni::Route.find(45)
    a = bus.inbound.stop_at("Union and Leavenworth").predictions
    arriving_in = {:first => a.first.minutes, :second => a.second.minutes,:third => a.third.minutes,}
    bustwo = Muni::Route.find(12)
    b = bustwo.outbound.stop_at("Pacific and Leavenworth").predictions
    arriving_in_2 = {:first => b.first.minutes, :second => b.second.minutes,:third => b.third.minutes,}
    response = Twilio::TwiML::Response.new do |r|
      r.Say "The 45 will depart in #{arriving_in[:first]}, #{arriving_in[:second]}, and #{arriving_in[:third]} minutes"
      r.Say "The 12 will depart in #{arriving_in_2[:first]}, #{arriving_in_2[:second]}, and #{arriving_in_2[:third]} minutes"
    end
    response.text
    
  elsif user_input == "2"
    bus = Muni::Route.find(45)
    a = bus.outbound.stop_at("3rd and Folsom").predictions
    arriving_in = {:first => a.first.minutes, :second => a.second.minutes,:third => a.third.minutes,}
    bustwo = Muni::Route.find(12)
    b = bustwo.inbound.stop_at("2nd and Howard").predictions
    arriving_in_2 = {:first => b.first.minutes, :second => b.second.minutes,:third => b.third.minutes,}
    response = Twilio::TwiML::Response.new do |r|
      r.Say "The 45 will depart in #{arriving_in[:first]}, #{arriving_in[:second]}, and #{arriving_in[:third]} minutes"
      r.Say "The 12 will depart in #{arriving_in_2[:first]}, #{arriving_in_2[:second]}, and #{arriving_in_2[:third]} minutes"
    end
    response.text
  end
  
end