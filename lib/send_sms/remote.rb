require "rubygems"
require "net/http"
require "net/https"
require "uri"
require 'cgi'

module Remote
  def set_header(cookie=nil,referer=nil)
    {"Cookie" => cookie , "Referer" => referer ,"Content-Type" => "application/x-www-form-urlencoded","User-Agent" => "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20091020 Ubuntu/9.10 (karmic) Firefox/3.5.3 GTB7.0" }
  end

  def connect(url)
    uri = URI.parse url
    http = Net::HTTP.new(uri.host,uri.port)
 
    if uri.scheme == "https"
      http.use_ssl = true
      http.ca_path = "/etc/ssl/certs"
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end
    cookie,referer = [nil,nil]
    self.url = url
    if url =='http://160by2.com'
      self.cookie,self.referer,self.response,self.http= nil, nil,nil,http
    else
      self.cookie,self.referer,self.response,self.http = fetch(http,'/content/index.html',set_header(cookie,referer))
    end

  end

  def fetch(http,path,header,data=nil,method=:get,limit=10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    cookie ||= header['Cookie']
    referer ||= header['Referer']
    if method == :get
      begin
        response = http.get(path,header.delete_if {|i,j| j.nil? })
      rescue
        return "Url not found"
      end
    else
      begin
        response = http.post(path,data,header.delete_if {|i,j| j.nil? })
      rescue
        return "Url not found"
      end
      cookie ||= response['set-cookie']
    end
    case response.code
    when   /2\d{2}/
      self.cookie,self.referer, self.response, self.http = cookie,referer,response,http
      return [self.cookie,self.referer, self.response, self.http]
    when  /3\d{2}/

      v =self.url.split('//')[1]
      reg = /http:\/\/#{v}\/(.+)/
      cookie,referer,response,http = fetch(http,("/"+response['location'].match(reg)[1]),set_header(cookie,(self.url+path)),limit-1)
      self.cookie,self.referer, self.response, self.http = cookie,referer,response,http
      return [cookie,referer,response,http]
    else
      return "HTTP Error"
    end
  end

end
