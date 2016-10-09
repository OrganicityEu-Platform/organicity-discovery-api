require 'net/http'
require 'json'

module Restful

  def send_request(end_point)
    request_url = URI.parse(URI.encode(end_point))
    cache_call(request_url)
  end

  def make_request(uri)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new(uri)
      request.add_field("fiware-service", "organicity") if uri.to_s.include? "orion"
      response = http.request request # Net::HTTPResponse object
      unless response.kind_of? Net::HTTPSuccess
        return Error.new(response)
      end
      return Response.new(response.body)
    end
  end

  def cache_call(url)
    call = RestCall.find(url: url).sort(by: :created_at)
    logger.warn "call: #{call.last.created_at}" unless call.empty?
    if call.empty? or ( Time.now > Time.parse(call.last.created_at) + 30.seconds )
      # We should extend cache if there is an error to preserve good results
      response = make_request(url)
      @cached_call = RestCall.create(url: url, created_at: Time.now, response: response.to_json)
      logger.warn "new request"
    else
      logger.warn "cached response"
      call = call.last
      @cached_call = call
    end

    return JSON.parse(@cached_call.response)
  end

  class Error
    def initialize(response)
      @error = JSON.parse({
        status: response.code,
        error: response.message,
        message: "HTTP Response: #{response.code} #{response.message}"
      }.to_s)
    end

    # Return JSON object.
    def error
      @error
    end

  end

  # Response object returned after a REST call to service.
  class Response

    def initialize(json)
      @doc = JSON.parse(json)
    end

    # Return JSON object.
    def doc
      @doc
    end

    # Return true if response has an error.
    def has_error?
      !(error.nil? || error.empty?)
    end

    # Return error message.
    def error
      @doc.has_key? "error"
    end

    # Return error code
    def error_code
      if @doc.has_key? "error"
        @doc["error"]["status"]
      end
    end

  end

  protected

  def log(s)
    if defined? RAILS_DEFAULT_LOGGER
      RAILS_DEFAULT_LOGGER.error(s)
    elsif defined? LOGGER
      LOGGER.error(s)
    else
      puts s
    end
  end
end
