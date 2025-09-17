require 'ostruct'

module ServiceContract
  def self.success(payload)
    OpenStruct.new(success?: true, payload: payload, errors: nil) 
  end

  def self.error(errors)
    OpenStruct.new(success?: false, payload: nil, errors: errors)
  end
end