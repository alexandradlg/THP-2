# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(50)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  it "should create a new lesson" do
    lesson = create(:lesson)
    expect(lesson).to be_valid
    expect(lesson.title).not_to be_blank
    expect(lesson.description).not_to be_blank
  end

  it { should validate_length_of(:title).is_at_most(50) }
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:description).is_at_most(300) }
  it { should validate_presence_of(:description) }
end
