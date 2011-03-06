#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  @title = 'urlmemo'
end


post '/add' do
  name = params['name']
  url = params['url']
  title = params['title']
  if !url or url.size < 1 or !title or title.size < 1
    @mes = {:error => 'url and title required'}.to_json
  else
    page = Page.new(:url => url, :time => Time.now.to_i, :title => title)
    if !name or name.size < 1
      if last_page = Page.where(:name.gt => 0).desc(:name).first
        page.name = last_page.name+1
      else
        page.name = 1
      end
    else
      page.name = name
    end
    page.save
    @mes = page.to_hash.to_json
  end
end

get '/' do
  @pages = Page.all.desc(:time)
  haml :index
end
