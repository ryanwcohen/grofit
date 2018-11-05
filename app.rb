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
