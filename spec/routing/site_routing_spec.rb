require 'spec_helper'

describe "site api request routing" do
 
  it "renders sites by uri as json" do
    expect(:get => '/api/v1/sites/cnn.com').to route_to(
      controller: "api/v1/sites",
      action:     "show",
      id:         "cnn.com",
      format:     "json"
    )
  end

  it "selects non-default policies" do
    expect(:get => '/api/v1/sites/cnn.com?policy=development').to route_to(
      controller: "api/v1/sites",
      action:     "show",
      id:         "cnn.com",
      policy:     "development",
      format:     "json"
    )
  end
  it "selects routes categorize requests to the #categorize action" do
    expect(:post => '/api/v1/sites/cnn.com/add?category=PASS_one').to route_to(
      controller: "api/v1/sites",
      action:     "add",
      category:   "PASS_one",
      id:         "cnn.com",
      format:     "json"
    )
  end
  it "selects routes categorize requests to the #categorize action" do
    expect(:post => '/api/v1/sites/cnn.com/remove?category=PASS_one').to route_to(
      controller: "api/v1/sites",
      action:     "remove",
      category:   "PASS_one",
      id:         "cnn.com",
      format:     "json"
    )
  end
end
