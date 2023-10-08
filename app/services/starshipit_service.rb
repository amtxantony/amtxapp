class StarshipitService
  include HTTParty
  base_uri 'https://api.starshipit.com'

  def initialize(api_key,sub_key)
    @options = { headers: { 
        'StarShipIT-Api-Key' => "#{api_key}",
        'Ocp-Apim-Subscription-Key' => "#{sub_key}"
      } }
  end

  def fetch_shipped_orders
    response = self.class.get('/api/orders/shipped', @options)
    response.parsed_response['orders'] if response.success?
  end
end