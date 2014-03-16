require 'spec_helper'

describe "policy request routing" do
 
  it "passes the named policy to the controller" do
    expect(:get => '/policies/production').to route_to(
      controller: "api/v1/policies",
      action:     "show",
      name:       "production"
    )
  end

  it "passes the desired format to the controller" do
    expect(:get => '/policies/production.txt').to route_to(
      controller: "api/v1/policies",
      action:     "show",
      name:       "production",
      format:     "txt"
    )
  end
end
