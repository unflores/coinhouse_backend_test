require 'rails_helper'

RSpec.describe User, type: :model do
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
end
