require "httparty"
require "pry"
require "sinatra"

set :bind, "0.0.0.0"

get "/" do
  response = HTTParty.get("https://api.warframe.market/v1/items/arcane_energize/statistics")
  @first = response["payload"]["statistics_closed"]["90days"][0]
  @second = response["payload"]["statistics_closed"]["90days"][1]
  erb :item
end
