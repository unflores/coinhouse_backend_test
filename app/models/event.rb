class Event < ApplicationRecord

  enum kind: [:workshop, :office_hours]

  belongs_to :user
  belongs_to :speaker, foreign_key: :speaker_id, class_name: 'User'

  has_and_belongs_to_many :attendees, class_name: 'User', before_add: :can_not_exceed_limit

  validates :limit, presence: true, numericality: { only_integer: true, greater_than: 0 }, if: :workshop?
  validates :limit, absence: true, if: :office_hours?

  validates_presence_of :date, :start_at, :end_at, :name, :location

  validate :can_not_be_in_the_past, :can_not_start_in_the_past, :can_not_start_after_end
  :must_be_the_same_day

  # after_validation :parse_date_time

  after_create :schedule_notifications

  private
  # def self.parse_date_time
  #   date = date.to_date
  #   start_at = DateTime.parse("#{date} #{start_at.strftime("%H:%M:%S %z")}")
  #   end_at = DateTime.parse("#{date} #{end_at.strftime("%H:%M:%S %z")}")
  # end

  def can_not_exceed_limit(_)
    raise ArgumentError.new('Event is full') if workshop? && limit && attendees.size >= limit
  end

  def can_not_be_in_the_past
    errors.add(:date, 'can not be in the past') if date && date < Date.today
  end

  def can_not_start_in_the_past
    errors.add(:start_at, 'can not be in the past') if start_at && start_at < 1.minute.ago
  end

  def can_not_start_after_end
    errors.add(:start_at, 'can not be greater than end_at') if start_at && end_at && start_at >= end_at
  end

  def must_be_the_same_day
    errors.add(:start_at, 'can not be greater than end_at') if start_at && end_at && start_at.to_date != end_at.to_date
  end

  def schedule_notifications
    RecallWorker.perform_at(start_at - 1.day, id)
    ThankYouWorker.perform_at(end_at + 1.hour, id)
  end
end
