require 'sinatra'
require 'muni'
require 'twilio-ruby'

get '/' do
  response = Twilio::TwiML::Response.new do |r|
    r.Gather :action => "input", :numDigits => 1 do
      r.Say "Hello Andrew are headed to Twilio... or headed home..."
      r.Say "Press 1 for Twilio..."
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
    b = bustwo.inbound.stop_at("Pacific and Leavenworth").predictions
    arriving_in_2 = {:first => b.first.minutes, :second => b.second.minutes,:third => b.third.minutes,}
    response = Twilio::TwiML::Response.new do |r|
      r.Say "The 45 will depart in #{arriving_in[:first]}, #{arriving_in[:second]}, and #{arriving_in[:third]} minutes"
      r.Say "The 21 will depart in #{arriving_in_2[:first]}, #{arriving_in_2[:second]}, and #{arriving_in_2[:third]} minutes"
    end
    response.text
    
  elsif user_input == "2"
    bus = Muni::Route.find(user_input)
    a = bus.outbound.stop_at("Union and Leavenworth").predictions
    arriving_in = {:minutes => a.first.minutes, :seconds => a.first.seconds}
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Hey Andrew the 45 outbound will arrive in #{arriving_in[:minutes]} minutes and #{arriving_in[:seconds]} seconds"
    end
    response.text
  end
  
end