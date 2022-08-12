require 'active_support/all'
require 'fedexvichuge/version'
require 'Faraday'

module Fedex
  module Rates
    class Error < StandardError; end
    @@quote_params = {
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

    def self.get(credentials, quote_params=@@quote_params)
      params = "
      <RateRequest xmlns='http://fedex.com/ws/rate/v13'>
        <WebAuthenticationDetail>
            <UserCredential>
                <Key>#{credentials[:key]}</Key>
                <Password>#{credentials[:password]}</Password>
            </UserCredential>
        </WebAuthenticationDetail>
        <ClientDetail>
            <AccountNumber>#{credentials[:account_number]}</AccountNumber>
            <MeterNumber>#{credentials[:meter_number]}</MeterNumber>
            <Localization>
                <LanguageCode>es</LanguageCode>
                <LocaleCode>mx</LocaleCode>
            </Localization>
        </ClientDetail>
        <Version>
            <ServiceId>crs</ServiceId>
            <Major>13</Major>
            <Intermediate>0</Intermediate>
            <Minor>0</Minor>
        </Version>
        <ReturnTransitAndCommit>true</ReturnTransitAndCommit>
        <RequestedShipment>
            <DropoffType>REGULAR_PICKUP</DropoffType>
            <PackagingType>YOUR_PACKAGING</PackagingType>
            <Shipper>
                <Address>
                    <StreetLines></StreetLines>
                    <City></City>
                    <StateOrProvinceCode>XX</StateOrProvinceCode>
                    <PostalCode>#{quote_params[:address_from][:zip]}</PostalCode>
                    <CountryCode>#{quote_params[:address_from][:country]}</CountryCode>
                </Address>
            </Shipper>
            <Recipient>
                <Address>
                    <StreetLines></StreetLines>
                    <City></City>
                    <StateOrProvinceCode>XX</StateOrProvinceCode>
                    <PostalCode>#{quote_params[:address_to][:zip]}</PostalCode>
                    <CountryCode>#{quote_params[:address_to][:country]}</CountryCode>
                    <Residential>false</Residential>
                </Address>
            </Recipient>
            <ShippingChargesPayment>
                <PaymentType>SENDER</PaymentType>
            </ShippingChargesPayment>
            <RateRequestTypes>ACCOUNT</RateRequestTypes>
            <PackageCount>1</PackageCount>
            <RequestedPackageLineItems>
                <GroupPackageCount>1</GroupPackageCount>
                <Weight>
                    <Units>#{quote_params[:parcel][:mass_unit].upcase}</Units>
                    <Value>#{quote_params[:parcel][:weight]}</Value>
                </Weight>
                <Dimensions>
                    <Length>#{quote_params[:parcel][:length].ceil}</Length>
                    <Width>#{quote_params[:parcel][:width].ceil}</Width>
                    <Height>#{quote_params[:parcel][:height].ceil}</Height>
                    <Units>#{quote_params[:parcel][:distance_unit].upcase}</Units>
                </Dimensions>
            </RequestedPackageLineItems>
        </RequestedShipment>
      </RateRequest>"
      res = request(params)
      format(res)
    end

    def self.request(params)
      response = client.post do |req|
        req.body = params
      end
      response.body
    end

    def self.client
      Faraday.new(
        url: 'https://wsbeta.fedex.com:443/xml',
        headers: {
          'Content-Type' => 'application/xml'
        }
      )
    end

    def self.format(res)
      # xml = Nokogiri::XML(res).to_xml
      h = Hash.from_xml(res)
      r = []
      h['RateReply']['RateReplyDetails'].each do |i|
        token = i['ServiceType']
        r.push({
          "price": i['RatedShipmentDetails'][0]['ShipmentRateDetail']['TotalNetChargeWithDutiesAndTaxes']['Amount'].to_f,
          "currency": i['RatedShipmentDetails'][0]['ShipmentRateDetail']['TotalNetChargeWithDutiesAndTaxes']['Currency'],
          "service_level": {
            "name": token.downcase.gsub('_', ' '),
            "token": token,
          }
        })
      end
      r
    end
  end
end
