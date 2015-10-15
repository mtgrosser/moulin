module Moulin
  class API
    
    API_HOST    = 'api.paymill.com'
    API_VERSION = 'v2'
    API_PORT    = 443
    
    attr_reader :key, :host, :port, :version
    
    def initialize(key, options = {})
      @key = key
      @host = options[:host] || API_HOST
      @port = options[:port] || API_PORT
      @version = options[:version] || API_VERSION
    end
    
    def destroy(base)
      delete base.class.api_path(base.id)
    end
    
    def update(base)
      assign base, put(base.class.api_path(base.id), base.attributes)
    end
    
    def create_payment(attrs = {})
      create Payment, attrs
    end
    
    def payments(options = {})
      all Payment, options
    end
    
    def find_payment(id)
      find Payment, id
    end
    
    def create_transaction(attrs = {})
      create Transaction, attrs
    end
    
    def transactions(options = {})
      all Transaction, options
    end
    
    def find_transaction(id)
      find Transaction, id
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
      @https = Net::HTTP.new(host, port)
      @https.use_ssl = true
      @https
    end
    
    def execute(request)
      response = https.start { |https| https.request(request) }
      log_response(response)
      raise AuthenticationError if 401 == response.code.to_i
      raise APIError if response.code.to_i >= 500
      payload = JSON.parse(response.body)
      raise APIError.new(payload['error']) if payload['error']
      payload['data']
    end
    
    def api_url(path, params = nil)
      encoded_params = "?#{URI.encode_www_form(params)}" if params && !params.empty?
      "https://#{host}/#{version}/#{path}#{encoded_params}"
    end
    
    def log_response(response)
      puts response.inspect
    end
    
    # FIXME: refactor
    def flatten_hash_keys(old_hash, new_hash = {}, keys = nil)
      old_hash.each do |key, value|
        key = key.to_s
        if value.is_a?(Hash)
          all_keys_formatted = keys + "[#{key}]"
          flatten_hash_keys(value, new_hash, all_keys_formatted)
        else
          new_hash[key] = value
        end
      end
      new_hash
    end

    # FIXME: refactor
    def normalize_params(params, key = nil)
      params = flatten_hash_keys(params) if params.is_a?(Hash)
      result = {}
      params.each do |key, value|
        case value
        when Hash
          result[key.to_s] = normalize_params(value)
        when Array
          value.each_with_index do |item_value, index|
            result["#{key.to_s}[#{index}]"] = item_value.to_s
          end
        else
          result[key.to_s] = value.to_s
        end
      end
      result
    end
    
  end
end
