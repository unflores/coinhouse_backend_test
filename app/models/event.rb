class Event < ApplicationRecord

  enum kind: [:workshop, :office_hours]

  belongs_to :user
  belongs_to :speaker, foreign_key: :speaker_id, class_name: 'User'

  has_and_belongs_to_many :attendees, class_name: 'User', before_add: :can_not_exceed_limit

  validates :limit, presence: true, numericality: { only_integer: true, greater_than: 0 }, if: :workshop?
  validates :limit, absence: true, if: :office_hours?

  validates_presence_of :date, :start_at, :end_at, :name, :location

  validate :can_not_be_in_the_past, :can_not_start_in_the_past,
    :can_not_start_after_end, :can_not_end_before_start

  private
  def can_not_exceed_limit
    errors.add(:attendees, 'event is full') if limit && limit == attendees.size
  end

  def can_not_be_in_the_past
    errors.add(:date, 'can not be in the past') if date < Date.today
  end

  def can_not_start_in_the_past
    errors.add(:start_at, 'can not be in the past') if start_at >= Time.now
  end

  def can_not_start_after_end
    errors.add(:start_at, 'can not be greater than end_at') if start_at >= end_at
  end

  def can_not_end_before_start
    errors.add(:end_at, 'can not be lower than start_at') if end_at <= start_at
  end
end
