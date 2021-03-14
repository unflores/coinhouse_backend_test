require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) { build_event.save } #todo remove after fixing seeding issue
  subject { build_user }

  describe 'validation' do
    context 'presence' do
      it 'no first_name' do
        subject.first_name = ''
        expect(subject).to_not be_valid
      end

      it 'no last_name' do
        subject.last_name = ''
        expect(subject).to_not be_valid
      end

      it 'no email' do
        subject.email = ''
        expect(subject).to_not be_valid
      end
    end

    context 'format' do
      it 'bad email' do
        subject.email = 'yolo'
        expect(subject).to_not be_valid
      end
    end

    context 'uniqueness' do
      it 'used email' do
        subject.dup.save
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'custom validation' do
    it 'can not have duplicates event' do
      Event.last.update(kind: 'office_hours')
      2.times { subject.registrations << Event.last }
      expect { subject.save validate: false }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
