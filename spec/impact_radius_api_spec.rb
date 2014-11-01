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
            <Ads page="1" numpages="1" pagesize="100" total="2" start="0" end="1" uri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads" firstpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=100&amp;Page=1" previouspageuri="" nextpageuri="" lastpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=100&amp;Page=3">
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

      context "all response 200" do
        before do
          xml_response1 = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse>
              <Ads page="1" numpages="3" pagesize="2" total="253" start="0" end="1" uri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2" firstpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=1" previouspageuri="" nextpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=2" lastpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=127">
                <Ad>
                  <Id>164487</Id>

                </Ad>
                <Ad>
                  <Id>164486</Id>
     
                </Ad>
              </Ads>
            </ImpactRadiusResponse>
            XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2"
          ).
          to_return(
            status: 200,
            body: xml_response1,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )
          xml_response2 = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse>
              <Ads page="2" numpages="3" pagesize="2" total="253" start="2" end="3" uri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=2" firstpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=1" previouspageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=1" nextpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=3" lastpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=127">
                <Ad>
                  <Id>164485</Id>
                 
                </Ad>
                <Ad>
                  <Id>164484</Id>

                </Ad>
              </Ads>
            </ImpactRadiusResponse>

            XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&Page=2"
          ).
          to_return(
            status: 200,
            body: xml_response2,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )
          xml_response3 = <<-XML
              <?xml version="1.0" encoding="UTF-8"?>
              <ImpactRadiusResponse>
                <Ads page="3" numpages="3" pagesize="2" total="253" start="4" end="5" uri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=3" firstpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=1" previouspageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&amp;Page=2" nextpageuri="" lastpageuri="">
                  <Ad>
                    <Id>164483</Id>
                    
                  </Ad>
                  <Ad>
                    <Id>164481</Id>
          
                  </Ad>
                </Ads>
              </ImpactRadiusResponse>
            XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2&Page=3"
          ).
          to_return(
            status: 200,
            body: xml_response3,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )
          ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
          ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
        end


        let(:mediapartners) {ImpactRadiusAPI::Mediapartners.new}
        let(:params)  {{ "PageSize" => "2" }}
        let(:response) {mediapartners.get("Ads", params)}

        it "get right first ID" do
          expect(response.all.first.Id).to eq("164487")
        end

        it "right last ID" do
          expect(response.all.last.Id).to eq("164481")
        end
      end
      context "promoads .all response 200" do
        before do
          xml_response1 = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse>
              <PromotionalAds page="1" numpages="3" pagesize="2" total="185" start="0" end="1" uri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Pagesize=2" firstpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=1" previouspageuri="" nextpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=2" lastpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=93">
                <PromotionalAd>
                  <Id>79094</Id>
                  <Status>ACTIVE</Status>
                  <PromoType>FREESHIPPING</PromoType>
                  <TrackingLink>http://goto.target.com/c/35691/79094/2092</TrackingLink>
                  <DiscountPercent/>
                  <DiscountMinPurchaseAmount>20.00</DiscountMinPurchaseAmount>
                </PromotionalAd>
                <PromotionalAd>
                  <Id>79095</Id>
                  <Status>ACTIVE</Status>
                  <PromoType>FREESHIPPING</PromoType>
                  <TrackingLink>http://goto.target.com/c/35691/79095/2092</TrackingLink>
                  <DiscountPercent/>
                  <DiscountMinPurchaseAmount>50.00</DiscountMinPurchaseAmount>
                </PromotionalAd>
              </PromotionalAds>
            </ImpactRadiusResponse>
            XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2"
          ).
          to_return(
            status: 200,
            body: xml_response1,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )
          xml_response2 = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse>
              <PromotionalAds page="2" numpages="3" pagesize="2" total="185" start="0" end="1" uri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Pagesize=2" firstpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=1" previouspageuri="" nextpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=3" lastpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=93">
                <PromotionalAd>
                  <Id>79096</Id>
                  <Status>ACTIVE</Status>
                  <PromoType>FREESHIPPING</PromoType>
                  <TrackingLink>http://goto.target.com/c/35691/79096/2092</TrackingLink>
                  <DiscountPercent/>
                  <DiscountMinPurchaseAmount>20.00</DiscountMinPurchaseAmount>
                </PromotionalAd>
                <PromotionalAd>
                  <Id>79097</Id>
                  <Status>ACTIVE</Status>
                  <PromoType>DOLLAROFF</PromoType>
                  <TrackingLink>http://goto.target.com/c/35691/79097/2092</TrackingLink>
                  <DiscountPercent/>
                  <DiscountMinPurchaseAmount>150.00</DiscountMinPurchaseAmount>
                </PromotionalAd>
              </PromotionalAds>
            </ImpactRadiusResponse>
            XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Page=2&PageSize=2"
          ).
          to_return(
            status: 200,
            body: xml_response2,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )

          xml_response3 = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse>
              <PromotionalAds page="3" numpages="3" pagesize="2" total="185" start="0" end="1" uri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Pagesize=2" firstpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=1" previouspageuri="" nextpageuri="" lastpageuri="//Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2&amp;Page=3">
                <PromotionalAd>
                  <Id>79098</Id>
                  <Status>ACTIVE</Status>
                  <PromoType>FREESHIPPING</PromoType>
                  <TrackingLink>http://goto.target.com/c/35691/79096/2092</TrackingLink>
                  <DiscountPercent/>
                  <DiscountMinPurchaseAmount>20.00</DiscountMinPurchaseAmount>
                </PromotionalAd>
                <PromotionalAd>
                  <Id>79099</Id>
                  <Status>ACTIVE</Status>
                  <PromoType>DOLLAROFF</PromoType>
                  <TrackingLink>http://goto.target.com/c/35691/79099/2092</TrackingLink>
                  <DiscountPercent/>
                  <DiscountMinPurchaseAmount>125.00</DiscountMinPurchaseAmount>
                </PromotionalAd>
              </PromotionalAds>
            </ImpactRadiusResponse>
            XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Page=3&PageSize=2"
          ).
          to_return(
            status: 200,
            body: xml_response3,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )
          ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
          ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
        end

        let(:mediapartners) {ImpactRadiusAPI::Mediapartners.new}
        let(:params)  {{ "PageSize" => "2" }}
        let(:response) {mediapartners.get("PromoAds", params)}

        it "get right first DiscountMinPurchaseAmount" do
          expect(response.all.first.DiscountMinPurchaseAmount).to eq("20.00")
        end

        it "right last DiscountMinPurchaseAmount" do
          expect(response.all.last.DiscountMinPurchaseAmount).to eq("125.00")
        end
      end
      
      context "404 responce" do
        before do
          xml_response = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse><Status>ERROR</Status><Message>The requested resource was not found</Message></ImpactRadiusResponse>
          XML
          stub_request(
            :get,
            "https://api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads"
          ).
            to_return(
              status: 404,
              body: xml_response,
              headers: { "Content-type" => "text/xml; charset=UTF-8" }
            )
          ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
          ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
        end

        it "raise invalid request error 404" do
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{mediapartners.get("Ads")}.to raise_error(ImpactRadiusAPI::InvalidRequestError, "The requested resource was not found")
        end
      end
    end
  end
  describe "Mediapartners" do
    describe ".xml_field" do
      before do
        ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
        ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
      end
      context "InvalidRequestError" do
        it "raise InvalidRequestError if not a media partner resource" do
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect{mediapartners.xml_field("Other")}.to raise_error(ImpactRadiusAPI::InvalidRequestError)
        end
      end
      context "valid resource" do
        it "returns PromotionalAds for resource PromoAds" do
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect(mediapartners.xml_field("PromoAds")).to eq("PromotionalAds")
        end
      end
    end
  end
end