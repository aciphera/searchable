# frozen_string_literal: true

class Author < ApplicationRecord
  include Searchable
  include AttachmentOptimizable

  GENDERS = %w[male female].freeze

  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :teachings
  has_many :follows, as: :content, dependent: :destroy
  has_many :favorites, as: :content, dependent: :destroy

  enum status: { unavailable: 0, available: 1 }
  enum target_audience: { all: 'all', men: 'men', women: 'women' },
       _prefix: true

  optimize_attachments :avatar

  validates :name, presence: true, uniqueness: true
  validates :gender, inclusion: { in: GENDERS }, allow_blank: true

  alias_attribute :display_name, :name

  scope(:by_target_audience, lambda { |gender|
    where(authors: { target_audience: gender })
  })
end
