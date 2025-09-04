# frozen_string_literal: true

class RunBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :distance, :time
  end
end
