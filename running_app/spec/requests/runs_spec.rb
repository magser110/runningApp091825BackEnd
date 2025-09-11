require 'rails_helper'

RSpec.describe "Runs", type: :request do
  let(:expected_run_structure) do
    {
      "distance"=> Integer,
      "time"=> Integer,
    }
  end


  describe "GET /index" do
    before do
      create_list(:run, 10)
      get "/runs"
      @response_body = JSON.parse(response.body)
    end

    it "returns runs" do
      @response_body.each do |run|
        expect(run.keys).to contain_exactly(*expected_run_structure.keys)
      end
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "does not return empty if runs exist" do
      expect(@response_body).not_to be_empty
    end

    it "returns 10 runs" do 
      expect(@response_body.size).to eq(10)
    end
  end

  describe "GET/show" do
    let (:run) { create(:run) }

    before do  
      get "/runs/#{run.id}"
      @response_body = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@response_body.keys).to contain_exactly(*expected_run_structure.keys)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST/create" do
    before do 
      post "/runs", params: attributes_for(:run)
      @response_body = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@response_body.keys).to contain_exactly(*expected_run_structure.keys)
    end

    it "count of runs should increase by 1" do
      expect(Run.count).to eq(1)
    end

    it "returns http success" do
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT/update" do
    let (:run) { create(:run) }

    before do
      put "/runs/#{run.id}", params: { distance: 5 }
      @response_body = JSON.parse(response.body)
    end


  it "checks for the correct structure" do 
    Rails.logger.debug @response_body
    expect( @response_body.keys).to contain_exactly(*expected_run_structure.keys)
  end
end

  it "checks if the distance is updated" do
    expect(run.reload.distance).to eq(5)
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
end

describe "DELETE/destroy" do
  let (:run) { create(:run) }

  before do 
    delete "/runs/#{run_id}"
  end

  it "decrements the count of runs by 1" do
    expect{
      delete "runs/#{run.id}"
    }.to change(Run.count).by(-1)
  end

  it "returns http success" do
    delete "/runs/#{run.id}"
    expect(response).to have_http_status(:success)
  end
end
