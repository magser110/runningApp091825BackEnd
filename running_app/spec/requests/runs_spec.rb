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
      @distance = JSON.parse(response.body)
    end

    it "returns runs" do
      @distance.each do |run|
        expect(run.keys).to contain_exactly(*expected_run_structure.keys)
      end
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "does not return empty if runs exist" do
      expect(@distance, @time).not_to be_empty
    end

    it "returns 10 runs" do 
      expect(@distance.size, @time.size).to eq(10)
    end
  end

  describe "GET/show" do
    let (:run_id) { create(:run).id }

    before do 
      get "/runs/#{run_id}"
      @distance = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@distance.keys).to contain_exactly(*expected_run_structure.keys)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST/create" do
    before do 
      post "/runs", params: attributes_for(:run)
      @distance = JSON.parse(response.body)
    end

    it "checks for the correct structure" do
      expect(@distance.keys).to contain_exactly(*expected_run_structure.keys)
    end

    it "count of runs should increase by 1" do
      expect(Run.count).to eq(1)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "PUT/update" do
    let (:run_id) { create(:run).id }

    before do
      put "/runs/#{run_id}", params: { distance: 'updated distance' }
      @distance = JSON.parse(response.body)
    end
  end

  it "checks for the correct structure" do 
    expect( @distance.keys).to contain_exactly(*expected_run_structure.keys)
  end

  it "checks if the distance is updated" do
    expect(Run.find(run_id).distance).to eq('updated distance')
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
end

describe "DELETE/destroy" do
  let (:run_id) { create(:run).id }

  before do 
    delete "/runs/#{run_id}"
  end

  it "decrements the count of runs by 1" do
    expect(Run.count).to eq(0)
  end

  it "returns http success" do
    expect(response).to have_http_status(:success)
  end
end
