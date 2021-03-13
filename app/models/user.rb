class User < ApplicationRecord

  has_many :events do
    def workshops; where(kind: 0) end
    def office_hours; where(kind: 1) end
  end
  has_many :speeches, class_name: 'Event', foreign_key: :speaker_id do
    def workshops; where(kind: 0) end
    def office_hours; where(kind: 1) end
  end

  has_and_belongs_to_many :registrations, class_name: 'Event' do
    def workshops; where(kind: 0) end
    def office_hours; where(kind: 1) end
  end

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_presence_of :first_name, :last_name
end
