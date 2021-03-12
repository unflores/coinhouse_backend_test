class User < ApplicationRecord

  has_many :events
  has_many :speeches, class_name: 'Event', foreign_key: :speaker_id

  has_and_belongs_to_many :registrations, class_name: 'Event'

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_presence_of :first_name, :last_name
end
