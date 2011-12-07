require 'rubygems'
require 'sinatra'
require 'builder'

post '/' do
  builder do |xml|
    xml.instruct!
    xml.Response do 
      xml.Say("Its a work in progress")
    end
  end
 #r45 = Muni::Route.find(45)
 #r45.outbound.stop_at("Union and Leavenworth").predictions
end

#16769