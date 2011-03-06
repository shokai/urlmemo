
class Page
  include Mongoid::Document
  field :url
  field :title
  field :name
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
