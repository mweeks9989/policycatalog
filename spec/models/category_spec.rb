require 'spec_helper'

describe Category do
  context "creating and removing categories" do
    it "requires descriptions" do 
      no_desc=Category.create(name: "no_desc")
      expect(no_desc).to have(1).error_on(:description)
    end

    it "requires names" do 
      no_name=Category.create(description: "no name")
      expect(no_name).to have(1).error_on(:name)
    end

    it "requires unique category names" do
      one=Category.create(name: "cat_one", description: "category one")
      two=Category.create(name: "cat_one", description: "category two")
      expect(two.errors_on(:name)).to include("has already been taken")
    end

    it "has no sites included after creation" do
      one=Category.create(name: "cat_one", description: "category one")
      expect(one.sites).to be_empty
    end
  end
end
