class DealData < ActiveRecord::Base
  attr_accessible :end_date, :start_date, :probability, :average_rate, :deal_id

  validates :deal_id, :presence => true, :uniqueness => true
  validates :average_rate, :numericality => true, :allow_blank => true
  validates :probability, :numericality => {
    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  }, :allow_blank => true
  validate :validate_start_date_before_end_date

  def date_range
    (start_date..end_date) if dates_present?
  end

  def daily_budget(price)
    if project_duration_in_days && project_duration_in_days > 0
      price / project_duration_in_days
    end
  end

  private

  def project_duration_in_days
    if dates_present?
      @project_duration_in_days ||= (end_date - start_date).to_i
    end
  end

  def dates_present?
    start_date && end_date
  end

  def validate_start_date_before_end_date
    errors.add(:end_date, "must be after the start date") if invalid_date_combination?
  end

  def invalid_date_combination?
    (start_date && end_date) && (start_date >= end_date)
  end
end
