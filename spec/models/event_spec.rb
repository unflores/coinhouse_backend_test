require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:all) { build_user.save } #todo remove after fixing seeding issue
  subject { build_event }

  it 'is valid' do
    expect(subject).to be_valid
  end

  describe 'validation' do
    context 'presence' do
      it 'no date' do
        subject.date = ''
        expect(subject).to_not be_valid
      end

      it 'no start_at' do
        subject.start_at = ''
        expect(subject).to_not be_valid
      end

      it 'no end_at' do
        subject.end_at = ''
        expect(subject).to_not be_valid
      end

      it 'no name' do
        subject.name = ''
        expect(subject).to_not be_valid
      end

      it 'no location' do
        subject.location = ''
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'custom validation' do
    it 'can not have duplicates user' do
      subject.kind = 'office_hours'
      2.times { subject.attendees << User.last }
      expect { subject.save validate: false }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'ignore limit if office_hours' do
      subject.kind = 'office_hours'
      subject.limit = nil
      expect { subject.attendees << User.last }.not_to raise_error
    end

    it 'can not exceed limit if workshop' do
      subject.kind = 'workshop'
      subject.limit = 0
      expect { subject.attendees << User.last }.to raise_error(ArgumentError)
    end

    context 'time' do
      it 'can not be in the past' do
        subject.date = Date.yesterday
        expect(subject).to_not be_valid
      end

      it 'can not start in the past' do
        subject.start_at = 1.hour.ago
        expect(subject).to_not be_valid
      end

      it 'can not start after end' do
        subject.end_at =  subject.start_at - 1.minute
        expect(subject).to_not be_valid
      end

      it 'can not be the same date' do
        subject.start_at =  Date.today.to_s
        subject.end_at =  Time.now
        expect(subject).to_not be_valid
      end
    end
  end
end
