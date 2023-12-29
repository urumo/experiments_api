# frozen_string_literal: true

class Distribution < ApplicationRecord
  attribute :percent_of_total, :float
  attribute :percent_of_key, :float

  # rubocop:disable Rails/InverseOf
  belongs_to :experiment, optional: true, foreign_key: :id
  # rubocop:enable Rails/InverseOf
  scope :not_fulfilled, -> { where('percent_of_key < chance') }

  default_scope { where.not(key: nil).or(where.not(value: nil)) }

  def readonly?
    true
  end
end
