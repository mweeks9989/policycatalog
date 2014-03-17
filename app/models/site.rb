class Site < ActiveRecord::Base
  POLICIES = %w{ production development test } 
  S_FORMAT = "%-40s; %s (%s) - %s"

  attr_readonly :uri, :comment

  validates :policy,  inclusion: { 
    in:      POLICIES,
    message: "must be one of: #{POLICIES.join(', ')}"
  }
  validates :comment, presence: true
  validates :uri,     presence: true, uniqueness: { 
    scope:   :policy, 
    message: "can only be included once per policy"
  }

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  before_validation :strip_scheme

  # cnn.com ; 2014-03-15 18:18:00 (rbreed) - this is the comment
  def to_s
    sprintf(S_FORMAT, uri, created_at.to_s, created_by, comment)
  end

  def to_param
    uri
  end

  def add(*items)
  end
  
  def remove(*items)
  end

  private
  def fetch_associated(item)
    case item
      when Category
        item
      when String
        Category.find_by_name(item)
      else
        nil
    end
  end

  def strip_scheme
    begin
      parsed=URI.parse(uri)
      if (parsed.path=="") && (! parsed.hostname.nil?)
        self.uri=parsed.hostname
      elsif parsed.hostname.nil?
        self.uri=parsed.path
      else
        self.uri=[parsed.hostname,parsed.path].join
      end
    rescue URI::InvalidURIError
      errors.add :uri, "Invalid URI: #{uri}"
    end
  end
end
