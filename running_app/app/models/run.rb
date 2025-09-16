class Run < ApplicationRecord
  belongs_to :user

  validates :distance, presence: true, numericality: { greater_than: 0 }
  validates :time, presence: true, numericality: { greater_than: 0 }  
  validates :date, presence: true
  validates :distance_limit
  validates :time_params

  before_save :calculate_metrics

  #pace in min/km
  def pace 
    return 0 if distance.zero?
    (time / 60) / distance
  end

  #average speed in km/h (time assumed in minutes)
  def average_speed
    return 0 if time.zero?
    distance / (time / 60.0)
  end

  private

  def calculate_metrics
    self.pace = pace
    self.average_speed = average_speed
    self.calories_burned = calculated_calories
    self.steps = calculated_steps
  end

  def calculated_steps
    #calculate steps/stride length by user height and gender
    stride_length = if user.gender == 'male'
      user.height * 0.415 #men: height * 0.415
    else
      user.height * 0.413 #women: height * 0.413
    end

    distance_meters = distance * 1000
    (distance_meters / stride_length).round
  end

  def calculated_calories
    # MET value for running (varies based on speed; using 9.8 as an average)
    avg_speed = average_speed
    met = if avg_speed < 8
            8.3 # jogging
          elsif avg_speed < 11
            9.8 # running 5-6 mph
          else
            11.3 # running 6-7 mph
          end

    #calories burned = MET * weight (kg) * time (hours)
    calories = met * user.weight * (time / 60.0)
    calories.round

    #age adujustment for metabolism (assuming 30 as baseline age and 0.5% decrease per year)
    age_adjustment = 1 - ((user.age - 30) * 0.005)

    #gender adjustment, men typically burn more calories
    gender_adjustment = user.gender == 'male' ? 1.1 : 1.0
    (calories * age_adjust * gender_adjustment).round
  end

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
