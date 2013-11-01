require 'faraday'
require 'faraday_middleware'
require 'rack'

module NationSync

  class API
    # include HTTParty
    @@endpoint = "https://.nationbuilder.com"
  
    def initialize(domain, access_token, session_cookie)
      @access_token   = access_token
      @session_cookie = session_cookie
    
      @conn = Faraday.new(:url => "https://#{domain}.nationbuilder.com") do |faraday|
        faraday.adapter(Faraday.default_adapter)
        faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      end
      @conn.headers['Cookie'] = "_nbuild_session=#{@session_cookie}"
      @conn.params["access_token"] = @access_token
    end
  
    def sites
      @conn.get("/admin/theme_tool_api/sites").body["sites"]
    end
  
    def themes
      @conn.get("/admin/theme_tool_api/themes").body["themes"]
    end
    def theme_assets(theme_id)
      @conn.get("/admin/theme_tool_api/themes/#{theme_id}/assets.json").body["assets"]
    end
  
    def pages
      @conn.get("/admin/theme_tool_api/pages.json").body["pages"]
    end
    
    def theme_asset_put(theme_id, fn, value)
      @conn.put do |req|
        req.url "/admin/theme_tool_api/themes/#{theme_id}/assets.json"
        req.params = {}
        # req.body = JSON.dump({
        req.body = Rack::Utils.build_nested_query({
          "access_token" => @access_token,
          "asset" => {
            "key" => fn,
            "value" => value
          }
        })
      end
      # data: {
      #   access_token: nation.get("accessToken"),
      #   asset: {
      #     key: file.filename,
      #     value: value,
      #     attachment: attachment
      #   }
      # },
    end
    def theme_asset_put_attachment(theme_id, fn, value)
      @conn.put do |req|
        req.url "/admin/theme_tool_api/themes/#{theme_id}/assets.json"
        req.params = {}
        req.body = Rack::Utils.build_nested_query({
          "access_token" => @access_token,
          "asset" => {
            "key" => fn,
            "attachment" => Base64.encode64(value)
          }
        })
      end
    end
  
  
  end#API
end#NationSync
