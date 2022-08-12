# Fedexvichuge

This gem has the purpose to be a coding challenge for Manuable.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fedexvichuge'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fedexvichuge

## Usage

- First of all, you need to create a credentials variable. This is a hash that contains your credentials for accessing the FedEx API.

```
credentials = {
  key: "xxxxxxxxxxxxxxxx",
  password: "xxxxxxxxxxxxxxxxxxxxxxxxx",
  account_number: "xxxxxxxxx",
  meter_number: "xxxxxxxxx"
}
```

- Now, create a new variable with the info for delivery, like:

```
quote_params = {
  address_from: {
         zip: "64000",
         country: "MX"
  },
     address_to: {
         zip: "64000",
         country: "MX"
  },
     parcel: {
         length: 25.0,
         width: 28.0,
         height: 46.0,
         distance_unit: "cm",
         weight: 6.5,
         mass_unit: "kg"
  }
}
```

- Once the credentials are set, you can use the `Fedexvichuge` class to access the FedEx API. Just type on the console `Fedex::Rates.get(credentials, quote_params)` and you'll get the response from the API with the rates on different service levels.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
