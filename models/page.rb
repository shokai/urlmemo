
class Page
  include Mongoid::Document
  field :url, :type => String
  field :title, :type => String
  field :name, :type => String
  field :time, :type => Integer

  def to_hash
    {
      :url => url,
      :title => title,
      :name => name,
      :time => time
    }
  end
end
