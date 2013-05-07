class DealData < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :probability, :average_rate, :deal_id

  validates :deal_id, :presence => true, :uniqueness => true
  validates :average_rate, :numericality => true, :allow_blank => true
  validates :probability, :numericality => {
    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  }, :allow_blank => true
  validate :validate_start_date_before_end_date

  private

  def validate_start_date_before_end_date
    errors.add(:end_date, "must be after the start date") if start_date_after_end_date? 
  end

  def start_date_after_end_date?
    (start_date && end_date) && (start_date > end_date)
  end
end
