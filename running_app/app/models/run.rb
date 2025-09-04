class Run < ApplicationRecord
  validates :distance, presence: true, length: { maximum: 350}
  validates :time, presence: true, length: { maximum: 80.hours}
end
