require 'net/http'
require 'json'

class Connect
  # Returns default Connection Parametes
  #
  # @return Hash with :scheme, :host, :port, :method, :query and :headers.
  # @note :headers is an object containing :Accept and :UserAgent
  def requireDefaults
    return {
      :scheme => 'https',
      :host => 'api.vimeo.com',
      :port => 443,
      :method => 'GET',
      :query => '',
      :headers => {
        :Accept => "application/vnd.vimeo.*+json;version=3.2",
        :UserAgent => 'Vimeo3RubyGem/0.0.1'
      }
    };
  end

  # Constructor
  #
  # @param [Type] clientID Client ID on Vimeo
  # @param [Type] clientSecret Client Secret on Vimeo
  # @param [Type] options = {} a Hash that may contain a Token. In the future may accept other parameters as well.
  def initialize(clientID, clientSecret, options = {})
    @clientID = clientID
    @clientSecret = clientSecret
    @token = options[:accessToken] if options[:accessToken]

    @tokenType = "basic"
    @tokenType = "bearer"  if options[:accessToken]

    @redirectURL = options[:redirectURL]
  end


  # Get Credentials for connection
  #
  # @return [String] Authentication Token for Header
  def setCredentials
    if @token.blank?
      creds = Base64.strict_encode64("#{@clientID}:#{@clientSecret}")
      return "basic #{creds}"
    else
      return "bearer #{@token}"
    end
  end


  # Description of method
  #
  # @return [Type] description of returned object
  def self.authEndpoints
    return {
      :authorization => '/oauth/authorize',
      :accessToken => '/oauth/access_token',
      :clientCredentials => '/oauth/authorize/client'
    };
  end

  # Get user's upload quota
  #
  # @param oAuthToken [String] OAuth Token for auth with Vimeo.
  # @param options [Hash] Options Hash, not used yet.
  # @return [Hash] upload_quota segment of Vimeo API's return JSON, converted to Hash.
  def getQuota(oAuthToken, options = {})
    defaults = requireDefaults
    headers = defaults[:headers]
    uri_params = defaults
    headers[:Authorization] = @tokenType+' '+@token
    uri_params[:path] = 'me'
    uri = URI::HTTP.new(uri_params)
    res = Net::HTTP::Get(uri, headers)

    if res.is_a?(Net::HTTPSuccess)
      body = JSON.parse(res.body)

      return body[:upload_quota]
    end

    return false
  end

  def getTicket(redirectURL)
    defaults = requireDefaults

    headers = defaults[:headers]
    body = {
      :redirect_url => redirectURL
    }

    uri_params = defaults

    headers[:Authorization] = @tokenType+' '+@token
    uri_params[:path] = '/me/videos'


    uri = URI::HTTP.build(uri_params)
    uri.scheme = uri_params[:scheme]


    req = Net::HTTP::Post.new(uri)


    #req.headers(headers)

    req.set_form_data(body)

    req.add_field 'Authorization', headers[:Authorization]


    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end


    if res.is_a?(Net::HTTPSuccess)
      body = JSON.parse(res.body)

      return body
    end

    return false
  end
end
