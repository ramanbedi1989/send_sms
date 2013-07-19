require 'spec_helper'
describe SendSms do
  it "To check if url is invalid" do
  	sms= SMS.new("http://160by2.c")
  	sms.cookie.should == "Url not found"
  	#s.login("9920822386", "beena$")
  	#sms =s.send_message('sa65sdf65645','9920822386', 'HELLO!!!!!!!!!!!!!!')
  	#sms
  end

  it "Valid url" do
  	sms= SMS.new("http://160by2.com")
  	sms.cookie.should == nil
  end

  it "Valid login" do
  	sms= SMS.new("http://160by2.com")
  	if sms.cookie.should == nil
  		test =sms.login("9920822386", "beena$")
  		valid = /LastLoginCookie/ =~ test[0]
  		valid.should_not == nil	

  	end
  end
end