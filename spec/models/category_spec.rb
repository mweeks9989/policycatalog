require 'spec_helper'

describe Category do
  context "creating categories with validation" do
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
  
  context "adding sites to a category" do 
    before(:each) do
      @cat  = Category.create(name: "cat_one",     description: "category one")
      @site =     Site.create(uri:  "siteone.com",     comment: "site one")
      @site2 =    Site.create(uri:  "sitetwo.com",     comment: "site two")
    end

    describe "#add" do
      it "adds single Site objects" do
        @cat.add(@site)
        expect(@cat.sites).to eq([@site])
      end

      it "adds multiple Site objects" do
        @cat.add(@site,@site2)
        expect(@cat.sites).to eq([@site,@site2])
      end
      
      it "adds single sites from uri strings" do
        @cat.add("siteone.com")
        expect(@cat.sites).to eq([@site])
      end

      it "adds single sites from uri strings" do
        @cat.add("siteone.com","sitetwo.com")
        expect(@cat.sites).to eq([@site,@site2])
      end

      it "adds mixed uri and site objects" do
        @cat.add("siteone.com",@site2)
        expect(@cat.sites).to eq([@site,@site2])
      end
      
      context "with invalid association" do
        it "rejects invalid categorization" do
          result=@cat.add(@site,@site)
          expect(result.errors[:base]).to include("siteone.com: Validation failed: Site cannot be included in the same category more than once")
        end
        it "rejects invalid uris" do
          result=@cat.add("womble")
          expect(result.errors[:base]).to include("womble: invalid uri, or site not in database")
        end
        it "rejects missing uris" do
          result=@cat.add(nil)
          expect(result.errors[:base]).to include(": invalid uri, or site not in database")
        end
      end
    end
  end
  context "removing sites from a category" do
    before(:each) do
      @cat  = Category.create(name: "cat_one",     description: "category one")
      @site =     Site.create(uri:  "siteone.com",     comment: "site one")
      @site2 =    Site.create(uri:  "sitetwo.com",     comment: "site two")
      @cat.sites << [@site, @site2]
    end

    describe "#remove" do
      it "removes individual sites by name" do
        @cat.remove("siteone.com")
        expect(@cat.sites).to eq([@site2])
      end

      it "removes multiple sites by name" do
        @cat.remove("siteone.com", "sitetwo.com")
        expect(@cat.sites).to eq([])
      end

      it "removes individual site objects" do
        @cat.remove(@site)
        expect(@cat.sites).to eq([@site2])
      end

      it "removes multiple site objects" do
        @cat.remove(@site,@site2)
        expect(@cat.sites).to eq([])
      end

      it "removes site as mixed strings and objects" do
        @cat.remove(@site,"sitetwo.com")
        expect(@cat.sites).to eq([])
      end

      context "with invalid association" do 
        it "succeeds for sites not already associated" do
          @cat.sites.remove(@site)
          result=@cat.remove(@site)
          expect(@cat.errors).to be_empty
          expect(result).to eq(@cat)
        end
        it "rejects invalid site names"
        it "rejects invalid objects"
      end
    end
  end
end
