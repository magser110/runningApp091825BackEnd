# frozen_string_literal: true

class RunBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :distance, :time, :date, :user_id
    association :user, blueprint: UserBlueprint


    field :total_stats do |run, options|
      options[:total_stats]
    end
  end
end
