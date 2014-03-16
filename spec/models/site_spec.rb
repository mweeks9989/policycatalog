require 'spec_helper'

describe Site do
  context "adding sites" do
    it "cannot be created without a uri" do
      no_uri=Site.create(comment: "no Uri")
      expect(no_uri.error_on(:uri)).to include("can't be blank")
    end
    it "cannot be created without a comment" do
      no_comment=Site.create(uri: "cnn.com")
      expect(no_comment.error_on(:comment)).to include("can't be blank")
    end
    it "is created with policy=production by default" do
      policy_default=Site.create(uri: "cnn.com", comment: "CNN")
      expect(policy_default.policy).to eq("production")
    end
    it "requires policy to be one of test, development,or production" do
      fail=Site.create(uri: "cnn.com", comment: "CNN", policy: "fail")
      test=Site.create(uri: "cnn.com", comment: "CNN", policy: "test")
      expect(fail.errors_on(:policy)).to include("must be one of: production, development, test")
      expect(test).to have(0).errors_on(:policy)
    end
    it "ensures uris are unique within a policy" do
      cnn_test=Site.create(uri: "cnn.com", comment: "CNN", policy: "test")
      cnn_fail=Site.create(uri: "cnn.com", comment: "CNN", policy: "test")
      expect(cnn_fail.errors_on(:uri)).to include("can only be included once per policy")
    end
    it "allows sites to be duplicated in separate policies" do
      cnn_test=Site.create(uri: "cnn.com", comment: "CNN", policy: "test")
      cnn_prod=Site.create(uri: "cnn.com", comment: "CNN", policy: "production")
      expect(cnn_prod).to have(0).errors_on(:uri)
    end
  end

  context "validating uris" do
    it "fails for invalid uris" do
      invalid=Site.create(uri: "----@:", comment: "invalid uri")
      expect(invalid.errors_on(:uri)).to include("Invalid URI: ----@:")
    end
  end

  context "stripping uri components" do
    it "strips everything from uri except the hostname and path" do
      schemed=Site.create(uri: "http://www.wibble.com/foo", comment: "has a scheme")
      expect(schemed.uri).to eq('www.wibble.com/foo')
    end
    it "saves hostname/path unaltered" do
      pathed=Site.create(uri: "wibble.com/foo", comment: "has a path and no scheme")
      expect(pathed.uri).to eq('wibble.com/foo')
      
    end
    it "saves bare hostnames unaltered" do
      hname=Site.create(uri: "wibble.com", comment: "has no path and no scheme")
      expect(hname.uri).to eq('wibble.com')
    end
  end
end
