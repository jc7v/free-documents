class Tag < ApplicationRecord
  has_and_belongs_to_many :documents

  validates :name, presence: true, length: {minimum: 3}

  def to_s
    name
  end
end
