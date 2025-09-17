# frozen_string_literal: true

class RunBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :distance, :time
    field :user do |run, options|
      options[:current_user]
    end

    field :total_stats do |run, options|
      options[:total_stats]
    end
  end
end
