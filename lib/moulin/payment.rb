module Moulin
  class Payment < Base
    attribute :id, :type, :client, :card_type, :country, :expire_month,
               :expire_year, :card_holder, :last4, :created_at, :updated_at, :app_id,
               :is_recurring, :is_usable_for_preauthorization, :holder, :account,
               :iban, :bic
       
  
    destroyable
  end
end