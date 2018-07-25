# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  title       :string(50)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at
end
