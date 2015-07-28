module Moulin
  class Transaction < Base
    attribute :id, :amount, :status, :description, :livemode,
                  :payment, :currency, :client, :response_code,
                  :origin_amount, :refunds, :source, :short_id
                  
    # base + update
  end
end