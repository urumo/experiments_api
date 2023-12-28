# frozen_string_literal: true

class Distribution < ApplicationRecord
  default_scope { where.not(key: nil).or(where.not(value: nil)) }
  def readonly?
    true
  end
end
