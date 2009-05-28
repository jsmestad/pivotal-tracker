require 'test_helper'

class ExtensionTest < Test::Unit::TestCase
  context String do
    should "return the string for to_param" do
      string = "my string!"
      assert_same string, string.to_param
    end
  end

  context Integer do
    should "return a string representation for to_param" do
      integer = 5
      assert_equal "5", integer.to_param
    end
  end
end
  

