require 'spec_helper'

describe Categorization do
  context "categorizing sites" do
    let(:cat_names) {
      %w{ one two three four five }
    }
    let(:categories) {
      cat_names.map {|c| Category.create(name: c, description: "category #{c}") }
    }
    let(:site) {
      Site.create(uri: "cnn.com", comment: "CNN")
    }
  
    before(:each) do
      site.categorizations.destroy_all
    end

    it "permits sites to be in 5 categories" do
      site.categories << categories
      expect(site).to be_valid
      expect(site.categories).to eq(categories)
    end  

    it "does not allow sites to be in the same category multiple times" do
      site.categories << categories[0]
      dupe_cat=Categorization.create(site_id: site.id, category_id: categories[0].id)
      expect(dupe_cat.errors_on(:site_id)).to include("cannot be included in the same category more than once")
    end
  end

  context "destroying sites" do
    let(:cat_names) {
      %w{ one two three four five }
    }
    let(:categories) {
      cat_names.map {|c| Category.create(name: c, description: "category #{c}") }
    }
    let(:site) {
      Site.create(uri: "cnn.com", comment: "CNN")
    }

    before(:all) do
      Category.destroy_all
      Categorization.destroy_all
      Site.destroy_all
    end

    it "removes associated categorizations upon site #destroy" do
      site.categories << categories
      expect(Categorization).to have(5).records
      site.destroy
      expect(Categorization).to have(:no).records
    end
  end
end
