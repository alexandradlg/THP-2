require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  describe "#index" do
    subject { get :index }
    let!(:lessons) { create_list(:lesson, 10) }

    it "returns all lessons" do
      subject
      expect(json_response.size).to eq(10)
    end

    it "returns response 200" do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe "#show" do
    subject { get(:show, params: { id: id }) }
    let(:lesson) { create(:lesson) }

    context "existing lesson id" do
      let(:id) { lesson.id }

      it "returns the right lesson" do
        subject
        expect(json_response[:id]).to eq(lesson.id)
        expect(json_response[:title]).to eq(lesson.title)
        expect(json_response[:description]).to eq(lesson.description)
      end

      it "returns response 200" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "nonexisting lesson id" do
      let(:id) { Faker::Number.number(3) }

      it "returns response 404" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#create" do
    subject { post(:create, params: { lesson: params }) }

    let(:params) do
      {
        title: title,
        description: description
      }
    end

    let(:title) { Faker::Lorem.words.first }
    let(:description) { Faker::Lorem.sentence(2) }

    context "with valid lesson params" do
      it "creates a lesson" do
        expect{ subject }.to change{ Lesson.count }.by(1)
      end

      it "returns the new lesson" do
        subject
        expect(json_response[:title]).to eq(title)
        expect(json_response[:description]).to eq(description)
      end

      it "returns response 201" do
        subject
        expect(response).to have_http_status(:created)
      end
    end

    context "with blank title" do
      let(:title) { " " }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('blank')
      end
    end

    context "without title" do
      before do
        params.delete(:title)
      end

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('Title')
      end
    end

    context "with blank description" do
      let(:description) { " " }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('blank')
      end
    end

    context "without description" do
      before do
        params.delete(:description)
      end

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('Description')
      end
    end

    context "with a too long title" do
      let(:title) { Faker::Lorem.sentence(50).first(700) }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('Title is too long')
      end
    end

    context "without params" do
      before do
        params.delete(:title)
        params.delete(:description)
      end

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('lesson')
      end
    end
  end

  describe "#update" do
    subject { patch(:update, params: { id: id, lesson: params }) }

    let(:params) do
      {
        title: title,
        description: description
      }
    end

    let!(:lesson) { create(:lesson) }
    let(:title) { Faker::Lorem.words.first }
    let(:description) { Faker::Lorem.sentence(2) }
    let(:id) { lesson.id }

    context "with a valid id" do
      it "returns the new lesson" do
        subject
        expect(json_response[:title]).to eq(title)
        expect(json_response[:description]).to eq(description)
      end

      it "updates the lesson" do
        expect{ subject }.to change{ lesson.reload.title }.to(title).and(change{ lesson.reload.description }.to(description))
      end

      it "returns response 200" do
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid id" do
      let(:id) { Faker::Number.number(3) }

      it "returns response 404" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context "with valid id and blank title" do
      let(:title) { " " }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('blank')
      end
    end

    context "with valid id and blank description" do
      let(:description) { " " }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('blank')
      end
    end

    context "with valid id and without params" do
      before do
        params.delete(:title)
        params.delete(:description)
      end

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('lesson')
      end
    end

    context "with a valid id and a too long title" do
      let(:title) { Faker::Lorem.sentence(50).first(700) }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('Title is too long')
      end
    end

    context "with a too long description" do
      let(:description) { Faker::Lorem.sentence(100).first(500) }

      it "returns response 403" do
        subject
        expect(response).to have_http_status(:forbidden)
      end

      it "returns the error message" do
        subject
        expect(json_response[:errors].first).to include('Description is too long')
      end
    end
  end

  describe "#delete" do
    subject { delete(:destroy, params: { id: id }) }
    let!(:lesson) { create(:lesson) }

    context "existing lesson id" do
      let(:id) { lesson.id }

      it "returns response 204" do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it "destroys the lesson" do
        expect{ subject }.to change(Lesson, :count).by(-1)
      end
    end

    context "nonexisting lesson id" do
      let(:id) { Faker::Number.number(3) }

      it "returns response 404" do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
