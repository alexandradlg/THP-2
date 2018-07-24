class LessonsController < ApplicationController
  def index
    lessons = Lesson.all
    render json: lessons
  end

  def show
    lesson = Lesson.find(params[:id])
    render json: lesson
  end

  def create
    lesson = Lesson.create!(lesson_params)
    render json: lesson, status: :created
  end

  def update
    lesson = Lesson.find(params[:id])
    lesson.update!(lesson_params)
    render json: lesson, status: :ok
  end

  def destroy
    Lesson.find(params[:id]).delete
    head :no_content
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description)
  end
end
