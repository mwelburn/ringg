require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :username => "exampleuser",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  # Most of the basic functionality is tested within Devise. We will just test extensions
  # of that functionality here

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  describe "validations" do

    it "should require a username" do
      no_username_user = User.new(@attr.merge(:username => ""))
      no_username_user.should_not be_valid
    end

    it "should reject usernames that are too long" do
      long_username = "a" * 21
      long_username_user = User.new(@attr.merge(:username => long_username))
      long_username_user.should_not be_valid
    end

    it "should reject usernames that include characters that aren't a number, letter, or underscore" do
      invalid_usernames = %w[test! test* &test]
      invalid_usernames.each do |invalid_username|
        invalid_username_user = User.new(@attr.merge(:username => invalid_username))
        invalid_username_user.should_not be_valid
      end

      invalid_username = "test name"
      invalid_username_user = User.new(@attr.merge(:username => invalid_username))
      invalid_username_user.should_not be_valid
    end

    it "should accept usernames that include characters inclusive of numbers, letters, and underscores" do
      valid_usernames = %w[test_1 43TEST ___]
      valid_usernames.each do |valid_username|
        valid_username_user = User.new(@attr.merge(:username => valid_username))
        valid_username_user.should be_valid
      end
    end

    it "should not require a name" do
      no_name_user = User.new(@attr.merge(:name => ""))
      no_name_user.should be_valid
    end

    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:name => long_name))
      long_name_user.should_not be_valid
    end

    describe "multiple users"

      before(:each) do
        @user2 = User.create!({
          :name => "Example User 2",
          :username => "exampleuser2",
          :email => "user2@example.com",
          :password => "foobar",
          :password_confirmation => "foobar"
        })
      end

      it "should require unique username" do
        user = User.new(@attr.merge(:username => "exampleuser2"))
        user.should_not be_valid
      end

      it "should not require unique name" do
        user = User.new(@attr.merge(:name => "Example User 2"))
        user.should be_valid
      end

      it "should require unique email" do
        user = User.new(@attr.merge(:email => "user2@example.com"))
        user.should_not be_valid
      end
  end

  describe "order" do

    before(:each) do
      @user1_attr = @attr
      @user2_attr = {
        :name => "Example User 2",
        :username => "exampleuser2",
        :email => "user2@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
      }
      @user3_attr = {
        :name => "Example User 3",
        :username => "exampleuser3",
        :email => "user3@example.com",
        :password => "foobar",
        :password_confirmation => "foobar"
      }
    end

    it "should return all users in the opposite order they were created" do
      user3 = User.create!(@user3_attr)
      user1 = User.create!(@user1_attr)
      user2 = User.create!(@user2_attr)
      User.all.should == [user2, user1, user3]
    end
  end

  describe "finger associations" do

    describe "should auto generate fingers upon user creation" do

      before(:each) do
        @user = User.create!(@attr)
      end

      it "should have fingers relationship" do
        @user.should respond_to(:fingers)
      end
    end

    describe "should not auto generate fingers if flag set" do

      it "should not create fingers if valid flag" do
        valid_flag = 1
        user = User.new(@attr)
        user.no_fingers = valid_flag
        user.save!
        user.fingers.size == 0
      end

      it "should create fingers if invalid flag" do
        invalid_flags = %w(0 true false &)
        invalid_flags.each do |invalid_flag|
          user = User.new(@attr.merge( {:email => generate(:email), :username => generate(:username)} ))
          user.no_fingers = invalid_flag
          user.save!
          user.fingers.size == 10
        end
      end

      it "should create fingers if no flag set" do
        user = User.create!(@attr)
        user.fingers.size == 10
      end

      describe "finger creation" do

        before(:each) do
          @user = User.new(@attr)
          @user.no_fingers = 1
          @user.save!
        end

        it "should allow finger creation later" do
          @finger1 = create(:finger, :user => @user, :side => 0, :digit => 0)
          @finger2 = create(:finger, :user => @user, :side => 1, :digit => 0)
          @finger3 = create(:finger, :user => @user, :side => 0, :digit => 1)
          @finger4 = create(:finger, :user => @user, :side => 1, :digit => 1)
          @finger5 = create(:finger, :user => @user, :side => 0, :digit => 2)
          @finger6 = create(:finger, :user => @user, :side => 1, :digit => 2)
          @finger7 = create(:finger, :user => @user, :side => 0, :digit => 3)
          @finger8 = create(:finger, :user => @user, :side => 1, :digit => 3)
          @finger9 = create(:finger, :user => @user, :side => 0, :digit => 4)
          @finger10 = create(:finger, :user => @user, :side => 1, :digit => 4)
          @user.fingers.size == 10
        end

        it "should have fingers the order of left to right, then thumb to pinky" do
          @finger1 = create(:finger, :user => @user, :side => 0, :digit => 0)
          @finger2 = create(:finger, :user => @user, :side => 1, :digit => 0)
          @finger3 = create(:finger, :user => @user, :side => 0, :digit => 1)
          @finger4 = create(:finger, :user => @user, :side => 1, :digit => 1)
          @finger5 = create(:finger, :user => @user, :side => 0, :digit => 2)
          @finger6 = create(:finger, :user => @user, :side => 1, :digit => 2)
          @finger7 = create(:finger, :user => @user, :side => 0, :digit => 3)
          @finger8 = create(:finger, :user => @user, :side => 1, :digit => 3)
          @finger9 = create(:finger, :user => @user, :side => 0, :digit => 4)
          @finger10 = create(:finger, :user => @user, :side => 1, :digit => 4)
          @user.fingers.should == [@finger1, @finger3, @finger5, @finger7, @finger9, @finger2, @finger4, @finger6, @finger8, @finger10]
        end
      end
    end
  end
end
