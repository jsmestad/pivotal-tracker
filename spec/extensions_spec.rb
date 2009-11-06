require File.dirname(__FILE__) + '/spec_helper'

describe "Extensions" do
  
  describe String do
    
    it "should return the string for to_param" do
      string = "my string!"
      string.to_param.should == "my string!"
    end
    
  end

  describe Integer do
    
    it "should return a string representation for to_param" do
      integer = 5
      integer.to_param.should == "5"
    end
    
  end
end
