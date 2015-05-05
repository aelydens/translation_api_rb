require 'httparty'
require 'dotenv'
Dotenv.load

class Translator
  include HTTParty

  def initialize(id, secret)
    @client_id = id
    @client_secret = secret
  end

  def getAccessToken
    params = {
      :grant_type => 'client_credentials',
      :client_id => @client_id,
      :client_secret => @client_secret,
      :scope => 'http://api.microsofttranslator.com'
    }
    response = self.class.post('https://datamarket.accesscontrol.windows.net/v2/OAuth2-13', :body => params)
    @accessToken = response["access_token"]
  end

  def translate(string, from, to)
    endpoint = "http://api.microsofttranslator.com/v2/Http.svc/Translate?text=" + url_encode(string) + "&from=" + from + "&to=" + to
    response = self.class.post(endpoint, :headers => { "Authorization" => "Bearer " + @accessToken })
  end

  def url_encode(string)
    string.gsub(" ", "+")
  end
end

client = Translator.new(ENV['CLIENT_ID'],
ENV['CLIENT_SECRET'])

puts client.getAccessToken

#puts client.translate("this+is+a+string", "en", "de")
