# ImpactRadiusApi

Ruby wrapper for [Impact Radius API](http://dev.impactradius.com/display/api/Home).  Only [Media Partner Resources](http://dev.impactradius.com/display/api/Media+Partner+Resources) is curently supported.

If you need services that are not yet supported, feel free to contribute. For questions or bugs please create an issue.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'impact_radius_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install impact_radius_api

## Configuration
This gem is designed to support [Media Partner Resources](http://dev.impactradius.com/display/api/Media+Partner+Resources).
All requests to the Impact Radius REST API require you to use HTTP Basic Authentication to convey your identity.

The username is your AccountSid (a 34 character string identifying your API account, starting with the letters "IR"). The password is your authentication token (AuthToken). These values are available on the Technical Settings page of your account. 

To start using the gem, you need to set up the AccountSid (username) and authentication token first. If you use Ruby on Rails, the API key can be set in a configuration file (i.e. `app/config/initializers/impact_radius.rb`), otherwise just set it in your script.

```ruby
require "impact_radius_api" # no need for RoR  :account_sid, :auth_token,
ImpactRadiusAPI.auth_token = ENV["IR_AUTH_TOKEN"]
ImpactRadiusAPI.account_sid = ENV["IR_ACCOUNT_SID"]
```
##Configuration Example
This applys to Ruby on Rails. Create ```app/config/initializer/impact_radius_api.rb``` and add the following:
```ruby
ImpactRadiusAPI.auth_token = ENV["IR_AUTH_TOKEN"]
ImpactRadiusAPI.account_sid = ENV["IR_ACCOUNT_SID"]
```
##Usage
###Media Partner Resources Ads
Will return all Banner and Text Link ads. See Impact Radius API Documentation [Ads](http://dev.impactradius.com/display/api/Campaign+Ads)
```ruby
require "impact_radius_api" #not needed for RoR
ImpactRadiusAPI.auth_token = ENV["IR_AUTH_TOKEN"]  #can be in app/config/initializer/impact_radius_api.rb of RoR
ImpactRadiusAPI.account_sid = ENV["IR_ACCOUNT_SID"] #can be in app/config/initializer/impact_radius_api.rb of RoR
mediapartners = ImpactRadiusAPI::Mediapartners.new
options = {
  type: "BANNER" #for only banner ads default is both banner and text link.
}
response = mediapartners.get("Ads", options)
response.data.each do |ad|
  puts "Name: #{ad.Name}"
  puts "Description: #{ad.Description}"
  puts "Link: #{ad.TrackingLink}"
end
```
If there are multiple pages, retrieve all the pages by using the ```all``` method:
```ruby
response.all.each do |ad|
  # Do stuff
end
```
###Media Partner Resources Product
Will return Products. See Impact Radius API Documentation [Products](http://dev.impactradius.com/display/api/Product+Data+System+Media+Partner+Resources)
Catalogs and ItemSearch will only work right now. ItemSearch is only for Retail.
```ruby
require "impact_radius_api" #not needed for RoR
ImpactRadiusAPI.auth_token = ENV["IR_AUTH_TOKEN"]  #can be in app/config/initializer/impact_radius_api.rb of RoR
ImpactRadiusAPI.account_sid = ENV["IR_ACCOUNT_SID"] #can be in app/config/initializer/impact_radius_api.rb of RoR
mediapartners = ImpactRadiusAPI::Mediapartners.new
options = {
  Query=Color:"Red"
}
response = mediapartners.get("Catalogs/ItemSearch", options)
response.data.each do |item|
  puts "Name: #{item.Name}"
  puts "Description: #{item.Description}"
  puts "Link: #{item.TrackingLink}"
end
```
###Media Partner List Catalog Items
Retrieves a list of specific catalog items using the catalog number.
```ruby
require "impact_radius_api" #not needed for RoR
ImpactRadiusAPI.auth_token = ENV["IR_AUTH_TOKEN"]  #can be in app/config/initializer/impact_radius_api.rb of RoR
ImpactRadiusAPI.account_sid = ENV["IR_ACCOUNT_SID"] #can be in app/config/initializer/impact_radius_api.rb of RoR
mediapartners = ImpactRadiusAPI::Mediapartners.new
options = {
  Query=Color:"Red"
}
response = mediapartners.get("Catalogs/{CatalogID}/Items", options)
response.data.each do |item|
  puts "Name: #{item.Name}"
  puts "Description: #{item.Description}"
  puts "Link: #{item.TrackingLink}"
end
```
CatalogId Intger required Id for specific Catalog.  Example 2255

If there are multiple pages, retrieve all the pages by using the ```all``` method:
```ruby
response.all.each do |item|
  # Do stuff
end
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/impact_radius_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
