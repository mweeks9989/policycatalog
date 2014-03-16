require 'spec_helper'

describe Api::V1::PoliciesController do
  it "renders policies by name" do
    get :show, { name: "production", format: "txt" }
    expect(response).to render_template("policies/show.txt.erb")
  end
end
