require 'rails_helper'

RSpec.describe Run, type: :model do
  
  context "valid attributes" do
    it "is valid with valid attributes" do 
      run = build(:run)
      expect(run).to be_valid
    end
  end

  context "invalid attributes" do
    it "is invalid without a distance" do
      run = build(:run, distance: nil)
      run.valid?
      expect(run.errors[:distance]).to include("can't be blank")
    end

    it "is invalid when distance is too far" do
      run = build(:run, distance: 1 * 350) 
      run.valid?
      expect(run.errors[:body]).to include("is too far (maximum is 350 miles)")
    end

    it "is invalid without a time" do
      run = build(:run, time: nil)
      run.valid?
      expect(run.errors[:time]).to include("time is not included")
    end

    it "is invalid if time is not positive" do
      run = build(:run, time: time > 0)
      run.valid?
      expect(run.errors[:time]).to include("time must be positive")
    end

    it "is invalid if time is too long" do
      run = build(:run, time > 80.hours)
      run.valid?
      expect(run.errors[:time]).to include("time must be less than 80 hours")
    end
  end
end
