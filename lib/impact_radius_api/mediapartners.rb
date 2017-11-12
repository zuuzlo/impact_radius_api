module ImpactRadiusAPI
  class Mediapartners < APIResource

    def xml_field(resource)
      case resource
      when "Ads"
        "Ads"
      when "PromoAds"
        "PromotionalAds"
      when "ActionInquiries"
        "ActionInquiries"
      when "Campaigns"
        "Campaigns"
      when "Actions"
        "Actions"
      when "Catalogs"
        "Catalogs"
      when "Items"
        "Items"
      when "Catalogs/ItemSearch"
        "Items"
      when /Catalogs\/\d{3,5}\/Items/
        "Items"
      else
        raise InvalidRequestError.new("#{resource} is not a valid Media Partner Resources. Refer to: http://dev.impactradius.com/display/api/Media+Partner+Resources for valid Media Partner Resources.")
      end
    end
  end
end