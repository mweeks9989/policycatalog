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
  it "passes updates to embedded site resources" do
    expect(:put=> '/api/v1/categories/BLOCK_test/sites/wibble.com').to route_to(
      controller:  "api/v1/sites",
      action:      "categorize",
      category_id: "BLOCK_test",
      id:          "wibble.com",
      format:      "json"
    )
  end

end
