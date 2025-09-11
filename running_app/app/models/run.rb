class Run < ApplicationRecord
  validates :distance, presence: true
  validates :time, presence: true
  validates :distance_limit
  validates :time_params
  
  private

  def distance_limit
    if distance.present? && distance > 350
      errors.add(:distance, "is too far (maximum is 350 miles)")
    end
  end

  def time_params
    if time.present? && time <=0
      errors.add(:time, "must be positive")
    elsif time.present? && time > 80.hours
      errors.add(:time, "must be less than 80 hours")
    end
  end
end
