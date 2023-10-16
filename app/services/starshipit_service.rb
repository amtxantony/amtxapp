require 'date'
require 'cgi'
require "uri"
require "json"
require "net/http"

class StarshipitService
  include HTTParty
  base_uri 'https://api.starshipit.com'

  def initialize()
    @options = { 
      headers: { 
        'StarShipIT-Api-Key' => "#{STARSHIPIT_KEY}",
        'Ocp-Apim-Subscription-Key' => "#{STARSHIPIT_SUBSCRIPTION_KEY}"
      }
    }
  end


  def fetch_shipped_orders(from_date)
    after_date = CGI.escape(DateTime.parse(from_date).rfc3339)
    response = self.class.get("/api/orders/shipped?since_last_updated=#{after_date}&ids_only=1", @options)
    response.parsed_response['orders'] if response.success?
  end

  def get_order(order_number)
    response = self.class.get("/api/orders?order_number=#{CGI.escape(order_number)}", @options)
    response if response.success?
  end

  def get_rates(data)
    # response = self.class.post("/api/rates", query: data, @options)
    # response if response.success?
    url = URI("https://api.starshipit.com/api/rates")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["StarShipIT-Api-Key"] = "#{STARSHIPIT_KEY}"
    request["Ocp-Apim-Subscription-Key"] = "#{STARSHIPIT_SUBSCRIPTION_KEY}"
    request.body = JSON.dump(data)

    response = https.request(request)
    return JSON.parse(response.body)
  end

end