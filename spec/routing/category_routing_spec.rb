require 'spec_helper'

describe "category api request routing" do

  before(:all) {
    Category.create( name: "BLOCK_test", description: "test category")
    Site.create(     uri:  "wibble.com", comment:     "test site")
  }

  it "renders categories by name as json" do
    expect(:get => '/api/v1/categories/BLOCK_test').to route_to(
      controller: "api/v1/categories",
      action:     "show",
      id:         'BLOCK_test',
      format:     "json"
    )
  end
  
  it "passes add to controller #add action" do
    expect(:post => '/api/v1/categories/BLOCK_test/add?uri=wibble.com&comment=test%20add').to route_to(
      controller:  "api/v1/categories",
      action:      "add",
      id:          "BLOCK_test",
      uri:         "wibble.com",
      comment:     "test add",
      format:      "json"
    )
  end

it "passes remove to controller #remove action" do
    expect(:post => '/api/v1/categories/BLOCK_test/remove?uri=wibble.com').to route_to(
      controller:  "api/v1/categories",
      action:      "remove",
      id:          "BLOCK_test",
      uri:         "wibble.com",
      format:      "json"
    )
  end


end
