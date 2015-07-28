module Moulin
  class Error < StandardError; end
  
  class AuthenticationError < Error; end
  class APIError < Error; end
end