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
              "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads"
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
            "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?PageSize=2"
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
            "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?Page=2&PageSize=2").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
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
            "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads?Page=3&PageSize=2").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
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
            "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?PageSize=2"
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
             "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Page=2&PageSize=2").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
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
             "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/PromoAds?Page=3&PageSize=2").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
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

      context "Products 200 responce" do
        before do
          xml_response = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
              <ImpactRadiusResponse>
                <Items pagesize="100" uri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/ItemSearch?Query=Color:red" firstpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/ItemSearch?PageSize=100&amp;Query=Color%3Ared" previouspageuri="" nextpageuri="/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/ItemSearch?PageSize=100&amp;AfterId=g2wAAAABaANkACdkYmNvcmVAZGIzLmltcGFjdHJhZGl1czAwMi5jbG91ZGFudC5uZXRsAAAAAm4EAAAAAKBuBAD___-_amgCRkADn-8AAAAAYgAiv4Vq&amp;Query=Color%3Ared">
                  <Item>
                    <Id>product_530_21460447</Id>
                    <CatalogId>530</CatalogId>
                    <CampaignId>2092</CampaignId>
                    <CampaignName>Target</CampaignName>
                    <CatalogItemId>21460447</CatalogItemId>
                    <Name>Allura 3/8 CT. T.W. Simulated Ruby Heart Pendant Necklace in Sterling Silver, Women's, Red</Name>
                    <Description>Find Fine Jewelry Necklaces, Bracelets, Anklets at Target.com! Allura 3/8 CT. T.W. Simulated Ruby Heart Pendant Necklace in Sterling Silver Color: Red. Gender: Female. Age Group: Adult.</Description>
                    <MultiPack/>
                    <Bullets/>
                    <Labels/>
                    <Manufacturer>Allura</Manufacturer>
                    <Url>http://goto.target.com/c/35691/78775/2092?aadid=21460447&amp;u=http%3A%2F%2Fwww.target.com%2Fp%2Fallura-3-8-ct-t-w-simulated-ruby-heart-pendant-necklace-in-sterling-silver%2F-%2FA-21460447</Url>
                    <MobileUrl/>
                    <ImageUrl>http://target.scene7.com/is/image/Target/21460447?wid=1000&amp;hei=1000</ImageUrl>
                    <ProductBid/>
                    <AdditionalImageUrls/>
                    <CurrentPrice>29.99</CurrentPrice>
                    <OriginalPrice>29.99</OriginalPrice>
                    <Currency>USD</Currency>
                    <StockAvailability>InStock</StockAvailability>
                    <EstimatedShipDate/>
                    <LaunchDate/>
                    <ExpirationDate/>
                    <Gtin>075000598628</Gtin>
                    <GtinType/>
                    <Asin/>
                    <Mpn/>
                    <ShippingRate>0.0</ShippingRate>
                    <ShippingWeight>1.0</ShippingWeight>
                    <ShippingWeightUnit>lb</ShippingWeightUnit>
                    <ShippingLength>8.0</ShippingLength>
                    <ShippingWidth>5.0</ShippingWidth>
                    <ShippingHeight>2.0</ShippingHeight>
                    <ShippingLengthUnit>in</ShippingLengthUnit>
                    <ShippingLabel/>
                    <Category/>
                    <OriginalFormatCategory>Apparel &amp; Accessories &gt; Jewelry &gt; Necklaces</OriginalFormatCategory>
                    <OriginalFormatCategoryId/>
                    <ParentName/>
                    <ParentSku/>
                    <IsParent>false</IsParent>
                    <Colors>
                      <Color>Red</Color>
                    </Colors>
                    <Material/>
                    <Pattern/>
                    <Size/>
                    <SizeUnit/>
                    <Weight>1.0</Weight>
                    <WeightUnit>lb</WeightUnit>
                    <Condition>New</Condition>
                    <AgeGroup>Adult</AgeGroup>
                    <Gender>Female</Gender>
                    <Adult>false</Adult>
                    <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/530/Items/product_530_21460447</Uri>
                  </Item>
                  <Item>
                    <Id>product_530_50320962</Id>
                    <CatalogId>530</CatalogId>
                    <CampaignId>2092</CampaignId>
                    <CampaignName>Target</CampaignName>
                    <CatalogItemId>50320962</CatalogItemId>
                    <Name>6ct Burgundy Shiny Finial Drilled Christmas Ornament Set, Red</Name>
                    <Description>Find Seasonal Holiday Decorations at Target.com! 8” Vickerman shiny finished finial ornament set of 6. These ornaments are a unique shape with a protective UV coating perfect for your decorating projects, whatever they may be. Color: Red.</Description>
                    <MultiPack/>
                    <Bullets/>
                    <Labels/>
                    <Manufacturer>Vickerman</Manufacturer>
                    <Url>http://goto.target.com/c/35691/78775/2092?aadid=50320962&amp;u=http%3A%2F%2Fwww.target.com%2Fp%2F6ct-burgundy-shiny-finial-drilled-christmas-ornament-set%2F-%2FA-50320962</Url>
                    <MobileUrl/>
                    <ImageUrl>http://target.scene7.com/is/image/Target/50320962?wid=1000&amp;hei=1000</ImageUrl>
                    <ProductBid/>
                    <AdditionalImageUrls/>
                    <CurrentPrice>40.74</CurrentPrice>
                    <OriginalPrice>40.74</OriginalPrice>
                    <Currency>USD</Currency>
                    <StockAvailability>InStock</StockAvailability>
                    <EstimatedShipDate/>
                    <LaunchDate/>
                    <ExpirationDate/>
                    <Gtin>734205385821</Gtin>
                    <GtinType/>
                    <Asin/>
                    <Mpn/>
                    <ShippingRate>0.0</ShippingRate>
                    <ShippingWeight>6.0</ShippingWeight>
                    <ShippingWeightUnit>lb</ShippingWeightUnit>
                    <ShippingLength>13.0</ShippingLength>
                    <ShippingWidth>9.0</ShippingWidth>
                    <ShippingHeight>9.0</ShippingHeight>
                    <ShippingLengthUnit>in</ShippingLengthUnit>
                    <ShippingLabel/>
                    <Category/>
                    <OriginalFormatCategory>Home &amp; Garden &gt; Decor &gt; Seasonal &amp; Holiday Decorations &gt; Holiday Ornaments</OriginalFormatCategory>
                    <OriginalFormatCategoryId/>
                    <ParentName/>
                    <ParentSku/>
                    <IsParent>false</IsParent>
                    <Colors>
                      <Color>Red</Color>
                    </Colors>
                    <Material/>
                    <Pattern/>
                    <Size/>
                    <SizeUnit/>
                    <Weight>6.0</Weight>
                    <WeightUnit>lb</WeightUnit>
                    <Condition>New</Condition>
                    <AgeGroup/>
                    <Gender/>
                    <Adult>false</Adult>
                    <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/530/Items/product_530_50320962</Uri>
                  </Item>
                  <Item>
                    <Id>product_530_50302458</Id>
                    <CatalogId>530</CatalogId>
                    <CampaignId>2092</CampaignId>
                    <CampaignName>Target</CampaignName>
                    <CatalogItemId>50302458</CatalogItemId>
                    <Name>Scholastic Trait Crate, Kindergarten, Six Books, Learning Guide, CD, More, Red</Name>
                    <Description>Find Educational Kits and Learning Tools at Target.com! Scholastic Trait Crate, Kindergarten, Six Books, Learning Guide, CD, More Color: Red.</Description>
                    <MultiPack/>
                    <Bullets/>
                    <Labels/>
                    <Manufacturer>Scholastic</Manufacturer>
                    <Url>http://goto.target.com/c/35691/78775/2092?aadid=50302458&amp;u=http%3A%2F%2Fwww.target.com%2Fp%2Fscholastic-trait-crate-kindergarten-six-books-learning-guide-cd-more%2F-%2FA-50302458</Url>
                    <MobileUrl/>
                    <ImageUrl>http://target.scene7.com/is/image/Target/50302458?wid=1000&amp;hei=1000</ImageUrl>
                    <ProductBid/>
                    <AdditionalImageUrls/>
                    <CurrentPrice>114.99</CurrentPrice>
                    <OriginalPrice>114.99</OriginalPrice>
                    <Currency>USD</Currency>
                    <StockAvailability>InStock</StockAvailability>
                    <EstimatedShipDate/>
                    <LaunchDate/>
                    <ExpirationDate/>
                    <Gtin>078073074709</Gtin>
                    <GtinType/>
                    <Asin/>
                    <Mpn/>
                    <ShippingRate>0.0</ShippingRate>
                    <ShippingWeight>2.6</ShippingWeight>
                    <ShippingWeightUnit>lb</ShippingWeightUnit>
                    <ShippingLength>9.75</ShippingLength>
                    <ShippingWidth>13.5</ShippingWidth>
                    <ShippingHeight>5.25</ShippingHeight>
                    <ShippingLengthUnit>in</ShippingLengthUnit>
                    <ShippingLabel/>
                    <Category/>
                    <OriginalFormatCategory>Media &gt; Books</OriginalFormatCategory>
                    <OriginalFormatCategoryId/>
                    <ParentName/>
                    <ParentSku/>
                    <IsParent>false</IsParent>
                    <Colors>
                      <Color>Red</Color>
                    </Colors>
                    <Material/>
                    <Pattern/>
                    <Size/>
                    <SizeUnit/>
                    <Weight>2.6</Weight>
                    <WeightUnit>lb</WeightUnit>
                    <Condition>New</Condition>
                    <AgeGroup/>
                    <Gender/>
                    <Adult>false</Adult>
                    <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/530/Items/product_530_50302458</Uri>
                  </Item>
                  <Item>
                    <Id>product_530_50304525</Id>
                    <CatalogId>530</CatalogId>
                    <CampaignId>2092</CampaignId>
                    <CampaignName>Target</CampaignName>
                    <CatalogItemId>50304525</CatalogItemId>
                    <Name>4ct Burgundy Assorted Finishes Christmas Ornament Set, Red</Name>
                    <Description>Find Seasonal Holiday Decorations at Target.com! 10” assorted finish Vickerman shatterproof ornaments come with 1 matte, 1 shiny, 1 glitter, and 1 sequin totaling 4 pieces. Shatterproof ornaments give you the look of real glass with the safety and reliability of plastic. These small ornaments are the perfect size for your decorating projects, whatever they may be. Color: Red.</Description>
                    <MultiPack/>
                    <Bullets/>
                    <Labels/>
                    <Manufacturer>Vickerman</Manufacturer>
                    <Url>http://goto.target.com/c/35691/78775/2092?aadid=50304525&amp;u=http%3A%2F%2Fwww.target.com%2Fp%2F4ct-burgundy-assorted-finishes-christmas-ornament-set%2F-%2FA-50304525</Url>
                    <MobileUrl/>
                    <ImageUrl>http://target.scene7.com/is/image/Target/50304525?wid=1000&amp;hei=1000</ImageUrl>
                    <ProductBid/>
                    <AdditionalImageUrls/>
                    <CurrentPrice>80.94</CurrentPrice>
                    <OriginalPrice>80.94</OriginalPrice>
                    <Currency>USD</Currency>
                    <StockAvailability>InStock</StockAvailability>
                    <EstimatedShipDate/>
                    <LaunchDate/>
                    <ExpirationDate/>
                    <Gtin>734205352731</Gtin>
                    <GtinType/>
                    <Asin/>
                    <Mpn/>
                    <ShippingRate>0.0</ShippingRate>
                    <ShippingWeight>5.0</ShippingWeight>
                    <ShippingWeightUnit>lb</ShippingWeightUnit>
                    <ShippingLength>21.0</ShippingLength>
                    <ShippingWidth>21.0</ShippingWidth>
                    <ShippingHeight>11.0</ShippingHeight>
                    <ShippingLengthUnit>in</ShippingLengthUnit>
                    <ShippingLabel/>
                    <Category/>
                    <OriginalFormatCategory>Home &amp; Garden &gt; Decor &gt; Seasonal &amp; Holiday Decorations &gt; Holiday Ornaments</OriginalFormatCategory>
                    <OriginalFormatCategoryId/>
                    <ParentName/>
                    <ParentSku/>
                    <IsParent>false</IsParent>
                    <Colors>
                      <Color>Red</Color>
                    </Colors>
                    <Material/>
                    <Pattern/>
                    <Size/>
                    <SizeUnit/>
                    <Weight>5.0</Weight>
                    <WeightUnit>lb</WeightUnit>
                    <Condition>New</Condition>
                    <AgeGroup/>
                    <Gender/>
                    <Adult>false</Adult>
                    <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/530/Items/product_530_50304525</Uri>
                  </Item>
                  <Item>
                    <Id>product_530_16620059</Id>
                    <CatalogId>530</CatalogId>
                    <CampaignId>2092</CampaignId>
                    <CampaignName>Target</CampaignName>
                    <CatalogItemId>16620059</CatalogItemId>
                    <Name>Pantone Expressions 5501R Runner - Warm (2'7X10'), Red</Name>
                    <Description>Find Rugs, Mats and Grips at Target.com! Energetic mid-century abstract expressionists splashed paint onto canvas in surprising ways. A few decades later, those splashes convey genuine feeling with a powerful color message. Expressions by Oriental Weavers for Pantone Universe is a new cross-woven rug collection with the energy and style of those mid-century artists. Cutting-edge creative technologies create a striking interplay of texture and painterly color in contemporary patterns. The colors used are:16-1359 Orange Peel18-2133 Pink Flamb'e18-1761 Ski Patrol13-0752 Lemon Size: 2'7X10' Runner. Color: Red. Gender: Unisex.</Description>
                    <MultiPack/>
                    <Bullets/>
                    <Labels/>
                    <Manufacturer>Pantone Universe</Manufacturer>
                    <Url>http://goto.target.com/c/35691/78775/2092?aadid=16620059&amp;u=http%3A%2F%2Fwww.target.com%2Fp%2Fpantone-expressions-5501r-runner-warm-2-7-x10%2F-%2FA-16620059</Url>
                    <MobileUrl/>
                    <ImageUrl>http://target.scene7.com/is/image/Target/16620059?wid=1000&amp;hei=1000</ImageUrl>
                    <ProductBid/>
                    <AdditionalImageUrls/>
                    <CurrentPrice>199.0</CurrentPrice>
                    <OriginalPrice>199.0</OriginalPrice>
                    <Currency>USD</Currency>
                    <StockAvailability>InStock</StockAvailability>
                    <EstimatedShipDate/>
                    <LaunchDate/>
                    <ExpirationDate/>
                    <Gtin>748679378463</Gtin>
                    <GtinType/>
                    <Asin/>
                    <Mpn/>
                    <ShippingRate>0.0</ShippingRate>
                    <ShippingWeight>11.0</ShippingWeight>
                    <ShippingWeightUnit>lb</ShippingWeightUnit>
                    <ShippingLength>31.0</ShippingLength>
                    <ShippingWidth>9.0</ShippingWidth>
                    <ShippingHeight>9.0</ShippingHeight>
                    <ShippingLengthUnit>in</ShippingLengthUnit>
                    <ShippingLabel/>
                    <Category/>
                    <OriginalFormatCategory>Home &amp; Garden &gt; Decor &gt; Rugs</OriginalFormatCategory>
                    <OriginalFormatCategoryId/>
                    <ParentName/>
                    <ParentSku/>
                    <IsParent>false</IsParent>
                    <Colors>
                      <Color>Red</Color>
                    </Colors>
                    <Material/>
                    <Pattern/>
                    <Size>2'7X10' Runner</Size>
                    <SizeUnit/>
                    <Weight>11.0</Weight>
                    <WeightUnit>lb</WeightUnit>
                    <Condition>New</Condition>
                    <AgeGroup/>
                    <Gender>Unisex</Gender>
                    <Adult>false</Adult>
                    <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/530/Items/product_530_16620059</Uri>
                  </Item>
                  <Item>
                    <Id>product_530_14771096</Id>
                    <CatalogId>530</CatalogId>
                    <CampaignId>2092</CampaignId>
                    <CampaignName>Target</CampaignName>
                    <CatalogItemId>14771096</CatalogItemId>
                    <Name>Rubbermaid 4 Pc. Premium Cansister Set, Red</Name>
                    <Description>Find Household Food or Beverage Storage Containers at Target.com! Rubbermaid 4 Pc. Premium Cansister Set Color: Red. Pattern: Solid.</Description>
                    <MultiPack/>
                    <Bullets/>
                    <Labels/>
                    <Manufacturer>Rubbermaid</Manufacturer>
                    <Url>http://goto.target.com/c/35691/78775/2092?aadid=14771096&amp;u=http%3A%2F%2Fwww.target.com%2Fp%2Frubbermaid-4-pc-premium-cansister-set%2F-%2FA-14771096</Url>
                    <MobileUrl/>
                    <ImageUrl>http://target.scene7.com/is/image/Target/14771096?wid=1000&amp;hei=1000</ImageUrl>
                    <ProductBid/>
                    <AdditionalImageUrls/>
                    <CurrentPrice>35.99</CurrentPrice>
                    <OriginalPrice>35.99</OriginalPrice>
                    <Currency>USD</Currency>
                    <StockAvailability>InStock</StockAvailability>
                    <EstimatedShipDate/>
                    <LaunchDate/>
                    <ExpirationDate/>
                    <Gtin>71691466499</Gtin>
                    <GtinType/>
                    <Asin/>
                    <Mpn/>
                    <ShippingRate>0.0</ShippingRate>
                    <ShippingWeight>4.63</ShippingWeight>
                    <ShippingWeightUnit>lb</ShippingWeightUnit>
                    <ShippingLength>9.75</ShippingLength>
                    <ShippingWidth>10.125</ShippingWidth>
                    <ShippingHeight>11.125</ShippingHeight>
                    <ShippingLengthUnit>in</ShippingLengthUnit>
                    <ShippingLabel/>
                    <Category/>
                    <OriginalFormatCategory>Home &amp; Garden &gt; Kitchen &amp; Dining &gt; Food Storage &gt; Food Storage Containers</OriginalFormatCategory>
                    <OriginalFormatCategoryId/>
                    <ParentName/>
                    <ParentSku/>
                    <IsParent>false</IsParent>
                    <Colors>
                      <Color>Red</Color>
                    </Colors>
                    <Material/>
                    <Pattern>Solid</Pattern>
                    <Size/>
                    <SizeUnit/>
                    <Weight>4.63</Weight>
                    <WeightUnit>lb</WeightUnit>
                    <Condition>New</Condition>
                    <AgeGroup/>
                    <Gender/>
                    <Adult>false</Adult>
                    <Uri>/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/530/Items/product_530_14771096</Uri>
                  </Item>
                </Items>
              </ImpactRadiusResponse>
            XML

          stub_request(
            :get,
            "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@product.api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Catalogs/ItemSearch?Query=Color:red"
          ).
          to_return(
            status: 200,
            body: xml_response,
            headers: { "Content-type" => "text/xml; charset=UTF-8" }
          )


          ImpactRadiusAPI.auth_token = "CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm"
          ImpactRadiusAPI.account_sid = "IRkXujcbpSTF35691nPwrFCQsbVBwamUD1"
        end

        let(:mediapartners) {ImpactRadiusAPI::Mediapartners.new}
        let(:params)  {{ "Query" => "Color:red" }}
        let(:response) {mediapartners.get("Catalogs/ItemSearch", params)}

        it "first item is correct" do
          expect(response.all.first.Id).to eq("product_530_21460447")
        end
      end
      
      context "404 response" do
        before do
          xml_response = <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <ImpactRadiusResponse><Status>ERROR</Status><Message>The requested resource was not found</Message></ImpactRadiusResponse>
          XML
          stub_request(
            :get,
            "https://IRkXujcbpSTF35691nPwrFCQsbVBwamUD1:CEdwLRxstFyC2qLAi58MiYe6sqVKD7Dm@api.impactradius.com/Mediapartners/IRkXujcbpSTF35691nPwrFCQsbVBwamUD1/Ads"
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
      context "add valid resource" do
        it "returns Catalogs/ItemSearch for ItemSearch" do
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect(mediapartners.xml_field("Catalogs/ItemSearch")).to eq("Items")
        end
      end
      context "Items for list catalog items" do
        it "returns Items for List Catalogs Items" do
          mediapartners = ImpactRadiusAPI::Mediapartners.new
          expect(mediapartners.xml_field("Catalogs/4525/Items")).to eq("Items")
        end
      end
    end
  end
end