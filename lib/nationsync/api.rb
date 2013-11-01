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
  
  
  end#API
end#NationSync
