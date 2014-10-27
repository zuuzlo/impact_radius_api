require 'spec_helper'

describe "impact_radius_api" do
  describe ".api_timeout" do
    context "time out integer and valid" do

      it "valid time sets @api_timeout" do
        ImpactRadiusAPI.api_timeout = 45
        expect(ImpactRadiusAPI.api_timeout).to eq(45)
      end
    end

    context "not valid timeout" do

      it "rasie Argument error if api_timeout is a string" do
        expect{ ImpactRadiusAPI.api_timeout = "45"}.to raise_error(ImpactRadiusAPI::ArgumentError,"Timeout must be a Fixnum; got String instead")
      end

      it "raise Argument error if api_timeout is below zero" do
        expect{ ImpactRadiusAPI.api_timeout = 0 }.to raise_error(ImpactRadiusAPI::ArgumentError,"Timeout must be > 0; got 0 instead")
      end 
    end
  end

  describe "ImpactRadiusAPI::APIResource" do
    describe ".class_name" do
      
      it "should return class name" do
        resource = ImpactRadiusAPI::Mediapartners.new
        expect(resource.class_name).to eq("Mediapartners")
      end
    end

    describe".base_path" do  
      it "should return error if APIResource" do
        resource = ImpactRadiusAPI::APIResource.new
        expect{resource.base_path}.to raise_error(ImpactRadiusAPI::NotImplementedError)
      end

      it "return base_path /Mediapartners/" do
        resource = ImpactRadiusAPI::Mediapartners.new
        expect(resource.base_path).to eq("/Mediapartners/")
      end
    end

    describe ".get(api_resource, params)" do
      context "no or invalid auth_token" do
        it "raises authentication error if no auth_token" do
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
        end

        it "raises authentication error if auth_token has spaces" do
          ImpactRadiusAPI.auth_token = "xxxxx xxxxx"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
        end

        it "raises authentication error if no Account SID" do
          ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
        end

        it "raises authentication error if account_sid (AccountSid) has space" do
          ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
          ImpactRadiusAPI.account_sid = "IRxxx xxx"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
        end

        it "raises authentication error if Account SID doesn't start with IR" do
          ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
          ImpactRadiusAPI.account_sid = "ERxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
        end

        it "raises authentication error if Account SID doesn't have 34 chars" do
          ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
          ImpactRadiusAPI.account_sid = "IRxxxxxx"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads") }.to raise_error(ImpactRadiusAPI::AuthenticationError)
        end
      end
      context "params is not a Hash" do
        it "raises ArgumentError if parms not a Hash" do
          ImpactRadiusAPI.auth_token = "xxxxxxxxxx"
          ImpactRadiusAPI.account_sid = "IRxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{ mediapartners.get("Ads", "user") }.to raise_error(ImpactRadiusAPI::ArgumentError)
        end
      end

      context "responce 200" do
        before do
          xml_response = <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <ImpactRadiusResponse>
            <Ads page="1" numpages="1" pagesize="100" total="2" start="0" end="1" uri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads" firstpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=100&amp;Page=1" previouspageuri="" nextpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=100&amp;Page=2" lastpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=100&amp;Page=3">
              <Ad>
                <Id>163636</Id>
                <Name>Free Shipping - 468x60</Name>
                <Description/>
                <CampaignId>2092</CampaignId>
                <CampaignName>Target</CampaignName>
                <Type>BANNER</Type>
                <TrackingLink>http://goto.target.com/c/35691/163636/2092</TrackingLink>
                <LandingPageUrl>http://www.target.com</LandingPageUrl>
                <Code>&lt;a href="http://goto.target.com/c/35691/163636/2092"&gt; &lt;img src="http://adn.impactradius.com/display-ad/2092-163636" border="0" alt=""/&gt; &lt;/a&gt; &lt;img height="1" width="1" src="http://goto.target.com/i/35691/163636/2092" border="0" /&gt;</Code>
                <IFrameCode>&lt;iframe src="http://adn.impactradius.com/gen-ad-code/35691/163636/2092/" scrolling="yes" frameborder="0" marginheight="0" marginwidth="0"&gt;&lt;/iframe&gt;</IFrameCode>
                <Width>469</Width>
                <Height>61</Height>
                <CreativeUrl>https://adn-ssl.impactradius.com/display-ad/2092-163636</CreativeUrl>
                <Tags/>
                <AllowDeepLinking>true</AllowDeepLinking>
                <MobileReady>false</MobileReady>
                <Language>ENGLISH</Language>
                <StartDate>2014-10-23T08:43:35-07:00</StartDate>
                <EndDate/>
                <Season/>
                <TopSeller>false</TopSeller>
                <DiscountCategory>FREESHIPPING</DiscountCategory>
                <DiscountSubCategory>ENTIRESTORE</DiscountSubCategory>
                <ProductName/>
                <ProductImageUrl/>
                <CouponCode/>
                <DiscountAmount/>
                <DiscountPercent/>
                <BeforePrice/>
                <AfterPrice/>
                <MinimumPurchaseAmount/>
                <SubjectLines/>
                <FromAddresses/>
                <UnsubscribeLink/>
                <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads/163636</Uri>
              </Ad>
              <Ad>
                <Id>163635</Id>
                <Name>Free Shipping - 320x50</Name>
                <Description/>
                <CampaignId>2092</CampaignId>
                <CampaignName>Target</CampaignName>
                <Type>BANNER</Type>
                <TrackingLink>http://goto.target.com/c/35691/163635/2092</TrackingLink>
                <LandingPageUrl>http://www.target.com</LandingPageUrl>
                <Code>&lt;a href="http://goto.target.com/c/35691/163635/2092"&gt; &lt;img src="http://adn.impactradius.com/display-ad/2092-163635" border="0" alt=""/&gt; &lt;/a&gt; &lt;img height="1" width="1" src="http://goto.target.com/i/35691/163635/2092" border="0" /&gt;</Code>
                <IFrameCode>&lt;iframe src="http://adn.impactradius.com/gen-ad-code/35691/163635/2092/" scrolling="yes" frameborder="0" marginheight="0" marginwidth="0"&gt;&lt;/iframe&gt;</IFrameCode>
                <Width>321</Width>
                <Height>51</Height>
                <CreativeUrl>https://adn-ssl.impactradius.com/display-ad/2092-163635</CreativeUrl>
                <Tags/>
                <AllowDeepLinking>true</AllowDeepLinking>
                <MobileReady>false</MobileReady>
                <Language>ENGLISH</Language>
                <StartDate>2014-10-23T08:43:35-07:00</StartDate>
                <EndDate/>
                <Season/>
                <TopSeller>false</TopSeller>
                <DiscountCategory>FREESHIPPING</DiscountCategory>
                <DiscountSubCategory>ENTIRESTORE</DiscountSubCategory>
                <ProductName/>
                <ProductImageUrl/>
                <CouponCode/>
                <DiscountAmount/>
                <DiscountPercent/>
                <BeforePrice/>
                <AfterPrice/>
                <MinimumPurchaseAmount/>
                <SubjectLines/>
                <FromAddresses/>
                <UnsubscribeLink/>
                <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads/163635</Uri>
              </Ad>
            </Ads>
          </ImpactRadiusResponse>
          XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads"
          ).
            to_return(
              status: 200,
              body: xml_response,
              headers: { "Content-type" => "text/xml; charset=UTF-8" }
            )
        end

        it "test to see url" do
          ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
          ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          response = mediapartners.get("Ads")
          expect(response.data.first.Id).to eq("163636")
        end
      end
    end
  end
end