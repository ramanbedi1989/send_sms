class SMS
  include Remote
  attr_accessor :http
  attr_accessor :cookie
  attr_accessor :response
  attr_accessor :referer
  attr_accessor :url

  def initialize(url)
    connect(url)
  end

  def login(username, password)
    new_http = http
    data = 'username='+username+'&password='+password+'&Submit=Login'
    if url == "http://160by2.com"
      action = "/re-login"
    else
      action ='/Login1.action'
    end
    cookie,referer,response,http = fetch(new_http,action,set_header(cookie,referer),data,:post)
  end

  def send_message(action, mobile_no, message)
    if message.length == 0 || message.length > 140
      p "Message should be only 140 characters"
    elsif mobile_no.length < 10 || mobile_no.length > 10
      p "Mobile number is wrong. It should contain only 10 numbers"
    else
      message = CGI.escape(message)
      if url == "http://160by2.com"
        action_name = "/SendSMSAction"
        sms_data = 'action1='+action+'&mobile1='+mobile_no+'&msg1='+message
      else
        action_name ='/quicksms.action'
        sms_data = 'HiddenAction=instantsms&Action='+action+'&MobNo='+mobile_no+'&textArea='+message
      end
      fetch(http,action_name,set_header(cookie,referer),sms_data,:post)
    end
  end
end

