class Finger < ActiveRecord::Base
  belongs_to :user

  attr_accessible :comment, :size

  validate :validate_ring_size

  validates :user_id, :presence => true
=begin
  0 = left
  1 = right
=end
  validates :side, :presence => true,
                   :numericality => {
                      :only_integer => true,
                      :greater_than_or_equal_to => 0,
                      :less_than_or_equal_to => 1,
                      :message => "must be a number between 0 and 1"
                   }
=begin
  0 = thumb
  1 = index
  2 = middle
  3 = ring
  4 = pinky
=end
  validates :digit, :presence => true,
                    :uniqueness => {
                       :scope => [:user_id, :side],
                       :message => "must be unique for a user's side"
                    },
                    :numericality => {
                       :only_integer => true,
                       :greater_than_or_equal_to => 0,
                       :less_than_or_equal_to => 4,
                       :message => "must be a number between 0 and 4"
                    }

  validates :size, :presence => false,
                   :numericality => {
                      :greater_than_or_equal_to => 0,
                      :less_than_or_equal_to => 16,
                      :message => "must be between 0 and 16",
                      :unless => Proc.new{ |finger| finger.size == -1 }
                   }

  default_scope :order => '"fingers"."side" ASC, "fingers"."digit" ASC'

  def self.DIGITS
    [0, 1, 2, 3, 4]
  end

  def self.SIDES
    [0, 1]
  end

  def as_json(options={})
    super(:only => [:id, :side, :digit, :size, :comment, :user_id])
  end

  private
    def validate_ring_size
      if size == -1
        #do nothing -- signifies blank
      elsif !size.blank? and size % 0.25 != 0
        errors.add(:size, "must be divisible by .25")
      end
    end
end
