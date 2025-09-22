# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :username, :email, :height, :weight, :gender, :age, :created_at, :updated_at
end
