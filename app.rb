require 'sinatra'
require 'muni'
require 'twilio-ruby'

get '/' do
  response = Twilio::TwiML::Response.new do |r|
    r.Gather :action => "input", :numDigits => 1 do
      r.Say "Hello Andrew are you inbound to or outbound from Twilio..."
      r.Say "Press 1 for inbound..."
      r.Say "Press 2 for outbound"
    end
  end
  response.text
end

post '/input' do
  user_input = params[:Digits]
  
  if user_input == "1"
    bus = Muni::Route.find(user_input)
    a = bus.inbound.stop_at("Union and Leavenworth").predictions
    arriving_in = {:minutes => a.first.minutes, :seconds => a.first.seconds}
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Hey Andrew the 45 inbound will arrive in #{arriving_in[:minutes]} minutes and #{arriving_in[:seconds]} seconds"
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