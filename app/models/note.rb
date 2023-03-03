# frozen_string_literal: true

# Model for notes
class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :body, type: String

  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
end
