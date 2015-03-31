class Vimeo3
  require 'vimeo_3/connect'
  @clientID
  @clientSecret
  @accessToken

  # Initializes Vimeo3 Object with parameters
  #
  # @param clientID [String] the Vimeo Client ID
  # @param clientSecret [String] the Vimeo Client Secret
  # @param options [Hash] an options parameter that may have an :accessToken key containing Vimeo's Access Token.
  # @return the object
  # @note to pass an Access Token pass "options" as { :accessToken => 'your_token_here' }.
  def initialize(clientID, clientSecret, options = {})
    @clientID = clientID
    @clientSecret = clientSecret
    @options = options
  end

  # Returns Vimeo3 Object's basic parameters
  #
  # @return a Hash with :clientID, :clientSecret and :accessToken
  # @note the returned :accessToken will be set to nil if it was not defined.
  def getValues
    return {
      :clientID => @clientID,
      :clientSecret => @clientSecret,
      :accessToken => @options[:accessToken]
    }
  end

  # Asks for UploadForm
  #
  # @param redirectURL [String] The URL to Redirect after Upload Completes
  # @return Upload View
  def getForm(redirectURL)
    vimeoConnection = Connect.new(@clientID, @clientSecret, @options)

    return vimeoConnection.getTicket(redirectURL)
  end
end
