module Moulin
  class API
    
    API_BASE      = 'api.paymill.com'
    API_VERSION   = 'v2'
    API_PORT      = 443
    
    attr_reader :key, :base, :version, :port
    
    def initialize(key, options = {})
      @key = key
      @base = options[:base] || API_BASE
      @version = options[:version] || API_VERSION
      @port = options[:port] || API_PORT
    end
    
    def delete(klass, id)
      delete klass.api_path(id)
    end

    def update(instance, attributes)
      assign instance, put(klass.api_path(instance.id), attributes)
    end
    
    def new_payment(attrs = {})
      Payment.new(self, attrs)
    end
    
    def payments(options)
      all(Payment, options)
    end
    
    def find_payment(id)
      find(Payment, id)
    end
    
    def new_transaction(attrs = {})
      build Transaction, attrs
    end
    
    def transactions(options)
      all(Transaction, options)
    end
    
    def find_transaction(id)
      find(Transaction, id)
    end
    
    private
    
    def create(klass, attributes)
      build klass, post(klass.api_path, attributes)
    end

    def find(klass, id)
      build klass, get(klass.api_path(id))
    end
    
    def all(klass, options = {})
      get(klass.api_path, options).map { |attributes| build klass, attributes }
    end
    
    def build(klass, attributes)
      klass.new(self, attributes)
    end
    
    def assign(instance, attributes)
      instance.attributes = attributes
      instance
    end
    
    def get(path, params = nil)
      execute init_request(:get, api_url(path, params))
    end
    
    def post(path, params = nil)
      request = init_request(:post, api_url(path))
      request.set_form_data(normalize_params(params)) if params
      execute request
    end
    
    def put(path, params = nil)
      request = init_request(:put, api_url(path))
      request.set_form_data(normalize_params(params)) if params
      execute request
    end
    
    def delete(path, params = nil)
      execute init_request(:delete, api_url(path, params))
    end
    
    def init_request(method, url)
      raise ArgumentError, "Illegal method #{method.inspect}" unless [:get, :post, :put, :delete].include?(method)
      request = Net::HTTP.const_get(method.to_s.capitalize).new(url)
      request.basic_auth(key, '')
      request
    end
    
    def https
      return @https if @https
      @https = Net::HTTP.new(base, port)
      @https.use_ssl = true
      @https
    end
    
    def execute(request)
      response = https.start { |https| https.request(request) }
      # log_request_info(response)
      raise AuthenticationError if 401 == response.code.to_i
      raise APIError if response.code.to_i >= 500
      payload = JSON.parse(response.body)
      raise APIError.new(payload['error']) if payload['error']
      payload['data']
    end
    
    def api_url(path, params = nil)
      encoded_params = "?#{URI.encode_www_form(params)}" if params && !params.empty?
      "https://#{base}/#{version}/#{path}#{encoded_params}"
    end
    
  end
end