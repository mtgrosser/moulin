# Moulin

An alternative Ruby wrapper for the Paymill API
(that does not rely on global configuration variables)

## Installation

In your Gemfile:

```ruby
gem 'moulin'
```

And then execute:

    $ bundle

## Usage

```ruby
paymill = Moulin::API.new('your private API key here')

paymill.find_payment('pay_42d88a4ae4d7b766eab02ce8')
=> #<Moulin::Payment @attributes={"id"=>"pay_42d88a4ae4d7b766eab02ce8", "type"=>"creditcard",
    "client"=>nil, "card_type"=>"visa", "country"=>"DE", "bin"=>"411111", "expire_month"=>"12",
    "expire_year"=>"2015", "card_holder"=>"", "last4"=>"1111", "updated_at"=>1424367668,
    "created_at"=>1424367668, "app_id"=>nil, "is_recurring"=>true,
    "is_usable_for_preauthorization"=>true}>
```
