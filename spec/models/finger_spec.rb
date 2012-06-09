require "spec_helper"

describe Finger do

  before(:each) do
    #since we are testing finger creation, users will not create fingers
    @user = create(:user, :no_fingers => 1)
    @user2 = create(:user, :no_fingers => 1)
    @attr = {
      :size => 4.25,
      :comment => "Normal size"
    }
  end

  it "should create a new instance given valid attributes" do
    finger = @user.fingers.new(@attr)
    finger.side = 1
    finger.digit = 3
    finger.save!
  end

  describe "user associations" do

    before(:each) do
      @finger = @user.fingers.new(@attr)
      @finger.side = 1
      @finger.digit = 3
      @finger.save!
    end

    it "should have a user attribute" do
      @finger.should respond_to(:user)
    end

    it "should have the right associated hand" do
      @finger.user_id.should == @user.id
      @finger.user.should == @user
    end
  end

  describe "validation" do

    it "should require a user id" do
      finger = Finger.new(@attr)
      finger.side = 1
      finger.digit = 3
      finger.should_not be_valid
    end

    it "should allow a blank comment" do
      finger = @user.fingers.build(@attr.merge({ :comment => "" }))
      finger.side = 1
      finger.digit = 3
      finger.should be_valid
    end

    it "should require a digit" do
      finger = @user.fingers.build(@attr)
      finger.side = 1
      finger.should_not be_valid
    end

    it "should require a unique digit per side" do
      finger1 = @user.fingers.build(@attr)
      finger1.side = 1
      finger1.digit = 3
      finger1.save!

      finger2 = @user.fingers.build(@attr)
      finger2.side = 1
      finger2.digit = 3
      finger2.should_not be_valid
    end

    it "should accept duplicate digits for unique side" do
      finger1 = @user.fingers.build(@attr)
      finger1.side = 1
      finger1.digit = 3
      finger1.save!

      finger2 = @user.fingers.build(@attr)
      finger2.side = 0
      finger2.digit = 3
      finger2.should be_valid
    end

    it "should reject non-numeric digits" do
      invalid_digits = %w(middle Mid MIDDLE Middle % *)
      invalid_digits.each do |invalid_digit|
        finger = @user.fingers.build(@attr)
        finger.side = 1
        finger.digit = invalid_digit
        finger.should_not be_valid
      end
    end

    it "should reject digits outside of 0 to 4" do
      invalid_digits = [-1, 5]
      invalid_digits.each do |invalid_digit|
        finger = @user.fingers.build(@attr)
        finger.side = 1
        finger.digit = invalid_digit
        finger.should_not be_valid
      end
    end

    it "should reject non-integer digits" do
      invalid_digits = [-0.3, 0.5, 1.0001, 1.0]
      invalid_digits.each do |invalid_digit|
        finger = @user.fingers.build(@attr)
        finger.side = 1
        finger.digit = invalid_digit
        finger.should_not be_valid
      end
    end

    it "should accept valid digits" do
      valid_digits = [0, 1]
      valid_digits.each do |valid_digit|
        finger = @user.fingers.build(@attr)
        finger.side = 1
        finger.digit = valid_digit
        finger.should be_valid
      end
    end

    it "should default ring size to -1" do
      finger = @user.fingers.build
      finger.size == -1
    end

    it "should not require a size" do
      finger = @user.fingers.build(@attr)
      finger.side = 1
      finger.digit = 1
      finger.should be_valid
    end

    it "should reject non-numeric size" do
      invalid_numbers = %w(a . $ _)
      invalid_numbers.each do |invalid_number|
        finger = @user.fingers.build(@attr.merge({ :size => invalid_number }))
        finger.side = 1
        finger.side = 3
        finger.should_not be_valid
      end
    end

    it "should accept valid sizes" do
      valid_numbers = [0, 1.25, 4.5, 6.50, 7.75, 16]
      valid_numbers.each do |valid_number|
        finger = @user.fingers.build(@attr.merge({ :size => valid_number }))
        finger.side = 1
        finger.digit = 3
        finger.should be_valid
      end
    end

    it "should not accept a blank size" do
      finger = @user.fingers.build(@attr.merge({ :size => "" }))
      finger.side = 1
      finger.digit = 3
      finger.should_not be_valid
    end
    
    it "should not accept a -1" do
      finger = @user.fingers.build(@attr.merge({ :size => -1 }))
      finger.side = 1
      finger.digit = 3
      finger.should be_valid
    end

    it "should not allow sizes below 0 except -1" do
      invalid_numbers = [-2, -0.5]
      invalid_numbers.each do |invalid_number|
        finger = @user.fingers.build(@attr.merge({ :size => invalid_number }))
        finger.side = 1
        finger.digit = 3
        finger.should_not be_valid
      end
    end

    it "should not allow sizes above 16" do
      invalid_numbers = [17, 16.25]
      invalid_numbers.each do |invalid_number|
        finger = @user.fingers.build(@attr.merge({ :size => invalid_number }))
        finger.side = 1
        finger.digit = 3
        finger.should_not be_valid
      end
    end

    it "should not allow decimals that aren't quarters" do
      invalid_numbers = [1.15, 4.35, 6.51, 7.756]
      invalid_numbers.each do |invalid_number|
        finger = @user.fingers.build(@attr.merge({ :size => invalid_number }))
        finger.side = 1
        finger.digit = 3
        finger.should_not be_valid
      end
    end

    it "should require a side" do
      finger = @user.fingers.build(@attr)
      finger.digit = 1
      finger.should_not be_valid
    end

    it "should reject non-numeric sides" do
      invalid_sides = %w(top left right !)
      invalid_sides.each do |invalid_side|
        finger = @user.fingers.build(@attr)
        finger.side = invalid_side
        finger.digit = 3
        finger.should_not be_valid
      end
    end

    it "should reject integer sides that are not 0 or 1" do
      invalid_sides = [-1, 2, 3]
      invalid_sides.each do |invalid_side|
        finger = @user.fingers.build(@attr)
        finger.side = invalid_side
        finger.digit = 3
        finger.should_not be_valid
      end
    end

    it "should reject non-integer sides" do
      invalid_sides = [0.1, 1.4, 1.00001, 1.0]
      invalid_sides.each do |invalid_side|
        finger = @user.fingers.build(@attr)
        finger.side = invalid_side
        finger.digit = 3
        finger.should_not be_valid
      end
    end

    it "should accept valid sides" do
      valid_sides = [0, 1]
      valid_sides.each do |valid_side|
        finger = @user.fingers.build(@attr)
        finger.side = valid_side
        finger.digit = 3
        finger.should be_valid
      end
    end

    it "should require unique sides" do
      finger1 = @user.fingers.build(@attr)
      finger1.side = 1
      finger1.digit = 3
      finger1.save!

      finger2 = @user.fingers.build(@attr)
      finger2.side = 1
      finger2.digit = 3
      finger2.should_not be_valid
    end

    it "should should allow duplicate sides for different users" do
      finger1 = @user.fingers.build(@attr)
      finger1.side = 1
      finger1.digit = 3
      finger1.save!

      finger2 = @user2.fingers.build(@attr)
      finger2.side = 1
      finger2.digit = 3
      finger2.should be_valid
    end
  end

  describe "order" do

    before(:each) do
      @finger1 = @user.fingers.build(@attr)
      @finger1.side = 0
      @finger1.digit = 0
      @finger1.save!
      @finger2 = @user.fingers.build(@attr)
      @finger2.side = 1
      @finger2.digit = 0
      @finger2.save!
      @finger3 = @user.fingers.build(@attr)
      @finger3.side = 0
      @finger3.digit = 1
      @finger3.save!
      @finger4 = @user.fingers.build(@attr)
      @finger4.side = 1
      @finger4.digit = 1
      @finger4.save!
      @finger5 = @user.fingers.build(@attr)
      @finger5.side = 0
      @finger5.digit = 2
      @finger5.save!
      @finger6 = @user.fingers.build(@attr)
      @finger6.side = 1
      @finger6.digit = 2
      @finger6.save!
      @finger7 = @user.fingers.build(@attr)
      @finger7.side = 0
      @finger7.digit = 3
      @finger7.save!
      @finger8 = @user.fingers.build(@attr)
      @finger8.side = 1
      @finger8.digit = 3
      @finger8.save!
      @finger9 = @user.fingers.build(@attr)
      @finger9.side = 0
      @finger9.digit = 4
      @finger9.save!
      @finger10 = @user.fingers.build(@attr)
      @finger10.side = 1
      @finger10.digit = 4
      @finger10.save!
    end

    it "should return all users in the order of left to right, then thumb to pinky" do
      Finger.all.should == [@finger1, @finger3, @finger5, @finger7, @finger9, @finger2, @finger4, @finger6, @finger8, @finger10]
    end
  end
end