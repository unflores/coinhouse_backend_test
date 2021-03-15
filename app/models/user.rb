class User < ApplicationRecord

  has_secure_password validations: false
  has_secure_token

  has_many :events do
    def workshops; where(kind: 0) end
    def office_hours; where(kind: 1) end
  end
  has_many :speeches, class_name: 'Event', foreign_key: :speaker_id do
    def workshops; where(kind: 0) end
    def office_hours; where(kind: 1) end
  end

  has_and_belongs_to_many :registrations, class_name: 'Event', before_add: :can_not_exceed_limit do
    def workshops; where(kind: 0) end
    def office_hours; where(kind: 1) end
  end

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :token

  def self.ransortable_attributes(auth_object = nil)
    column_names - %w(password_digest token)
  end

  def name
    "#{first_name} #{last_name}"
  end

  private
  def can_not_exceed_limit(event)
    if event.workshop? && event.limit && event.attendees.size >= event.limit
      raise ArgumentError.new('event is full')
    end
  end
end
