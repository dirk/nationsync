require 'nationsync'
require 'listen'
require 'thor'
require 'highline'
require 'pp'

class NationSyncThor < Thor
  HL = HighLine.new
  
  no_commands do
    def load_project_file
      
    end
    def cwd
      Dir.pwd
    end
    def setup_config
      return if @config
      @config = YAML.load_file(File.join(cwd, '.nbconfig1'))
      @domain = @config["domain"]
      @access_token = @config["access_token"]
      @session_id   = @config["session_id"]
    end
    def setup_api
      return if @api
      @api = NationSync::API.new(@domain, @access_token, @session_id)
    end
    def save_config!
      fn = File.join(cwd, '.nbconfig1')
      File.open(fn, 'w') { |f| YAML.dump(@config, f) }
    end
  end#/no_commands
  
  desc "init", "Initialize a theme in this directory"
  def init
    puts "Creating .nbconfig1"
    domain   = HL.ask("Domain: ").to_s
    email    = HL.ask("Email: ").to_s
    password = HL.ask("Password: ") {|q| q.echo = false }.to_s
    
    print "Fetching credentials..."
    auth = NationSync::Auth.new(domain, email, password)
    auth.authenticate!
    puts " Done"
    
    @config = {
      "domain" => domain,
      "email"  => email,
      "access_token" => auth.access_token,
      "session_id" => auth.session_id
    }
    save_config!
    puts "Created: #{fn}"
  end
  
  desc "watch", "Watch current directory for changes"
  def watch
    setup_config
    setup_api
    unless @config["asset_keys"]
      puts "Please run `nationsync fetch` to get an up-to-date asset list."
      return
    end
    listener = Listen.to(Dir.getwd) do |modified, added, removed|
      modified.each do |path|
        fn = File.basename(path)
        if !@config["asset_keys"].include?(fn)
          puts "- Skipping #{fn}"
        end
        type = MIME::Types.type_for(fn).first
        if type.binary?
          resp = @api.theme_asset_put_attachment(@config["theme_id"], fn, File.read(path))
        else
          resp = @api.theme_asset_put(@config["theme_id"], fn, File.read(path))
        end
        
        if resp.status == 200
          if resp.body["success"].to_s == "true"
            puts "- Updated #{fn}" + (type.binary? ? " (binary)" : "")
          else
            puts "- #{HL.color("Error", :red) } updating #{fn}:"
            errors = resp.body["errors"]
            if errors.is_a? Array
              errors.each {|e| puts "    #{e}"}
            else
              puts "    #{errors.to_s}"
            end
          end
        else
          puts "- #{HL.color("Error", :red) } updating #{fn}:"
          puts "    #{resp.body.to_s}"
        end
      end
      added.each do |path|
        fn = File.basename(path)
        puts "- #{HL.color("Warning:", :red)} File addition not supported yet (#{fn})"
      end
      removed.each do |path|
        fn = File.basename(path)
        puts "- #{HL.color("Warning:", :red)} File deletion not supported yet (#{fn})"
      end
    end#listener
    listener.start
    puts "Listening for changes in #{Dir.getwd}"
    sleep
  end#watch
  
  desc "clear", "Removes asset files according to manifest in .nbconfig1"
  def clear
    setup_config
    setup_api
    unless @config["asset_keys"]
      puts "Please run `nationsync fetch` to get an up-to-date asset list."
      return
    end
    print "Removing #{@config["asset_keys"].length.to_s} files..."
    @config["asset_keys"].each do |fn|
      File.delete(File.join(cwd, fn))
    end
    @config.delete "asset_keys"
    save_config!
    puts " Done"
  end
  
  desc "fetch", "Fetch files"
  def fetch
    setup_config
    setup_api
    unless @config["theme_id"]
      self.pick_theme
    end
    print "Fetching assets for theme #{@config["theme_id"]}..."
    assets = @api.theme_assets(@config["theme_id"])
    puts " Done"
    # if (window.is_binary(file_path)) {
    #   attachment = Ti.Codec.encodeBase64(content);
    # } else {
    #   value = content.toString();
    # }
    print "Writing files..."
    assets.each do |a|
      # puts "#{a["key"]}: #{a.keys.inspect}"
      fn = a["key"]
      data = a["value"]
      if a["attachment"]
        data = Base64.decode64(a["attachment"])
      end
      File.open(File.join(cwd, fn), 'w') {|f| f.write data }
    end
    puts " Done. (#{assets.length.to_s} Assets)"
    @config["asset_keys"] = assets.map {|a| a["key"] }
    save_config!
  end
  
  desc "pick_theme", "Pick theme"
  def pick_theme
    setup_config
    setup_api
    print "Fetching themes for selection..."
    themes = @api.themes
    puts " Done"
    # pp themes
    
    id = HL.choose do |m|
      m.prompt = "Select a theme: "
      
      themes.each do |t|
        # m.choice(t["id"])
        s = t["name"] + HL.color(" (#{t["id"]})", :gray)
        unless t["sites"].to_s.empty?
          s += "\n     (Site: " + t["sites"].to_s + ")"
        end
        m.choice(s) { t["id"] }
      end
    end
    @config["theme_id"] = id
    save_config!
    puts "Using theme #{id}"
  end
  

end#NationSyncThor

NationSyncThor.start
