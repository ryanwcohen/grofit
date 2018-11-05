require "httparty"
require "pry"
require "sinatra"
require "sinatra/reloader" if development?

set :bind, "0.0.0.0"

get "/" do
  erb :index
end

get "/endo" do
  @results = {}
  sculptures = {
    "anasa" => 3450,
    "orta" => 2700,
    "vaya" => 1800,
    "piv" => 1725,
    "valana" => 1575,
    "sah" => 1500,
    "ayr" => 1425
  }
  sculptures.keys.each do |sculpture|
    address ="https://api.warframe.market/v1/items/#{sculpture}_ayatan_sculpture/statistics"
    response = HTTParty.get(address)
    source = response["payload"]["statistics_closed"]["90days"][0]
    @results[sculpture] = {
      endo: sculptures[sculpture],
      wa_price: source["wa_price"],
      endo_plat: sculptures[sculpture] / source["wa_price"],
      volume: source["volume"]
    }
  end
  erb :ayatans
end

get "/arcanes" do
  @results = {}
  arcanes = %w(tempo momentum velocity guardian trickery ultimatum strike awakening acceleration fury avenger agility eruption rage precision consequence phantasm nullifier ice warmth arachne aegis barrier grace energize victory pulse healing deflection resistance)
  arcanes.sort.each do |arcane|
    address ="https://api.warframe.market/v1/items/arcane_#{arcane}/statistics"
    response = HTTParty.get(address)
    rank0 = response["payload"]["statistics_closed"]["90days"][1]
    rank3 = response["payload"]["statistics_closed"]["90days"][0]
    @results[arcane] = {
      rank0_wa_price: rank0["wa_price"],
      rank0_volume: rank0["volume"],
      rank3_wa_price: rank3["wa_price"],
      rank3_volume: rank3["volume"],
      rank3_premium: (((rank3["wa_price"]/10) - rank0["wa_price"])/rank0["wa_price"])*100
    }
  end
  erb :arcanes
end
