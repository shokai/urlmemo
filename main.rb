#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  @title = 'urlmemo'
end

post '/add' do
  name = params['name']
  url = params['url']
  title = params['title']
  begin
    raise Err.new 'url and title required' if !url or url.size < 1 or !title or title.size < 1
    page = Page.new(:url => url, :time => Time.now.to_i, :title => title)
    if !name or name.size < 1
      if last_page = Page.where(:name.gt => 0).desc(:name).first
        page.name = last_page.name+1
      else
        page.name = 1
      end
    else
      raise Err.new('page already exists') if Page.where(:name => name).count > 0
      if tmp = Page.where(:url => url).first
        raise Err.new("url already exists => #{app_root}/#{tmp.name}") 
      end
      page.name = name
    end
    page.save
    @mes = page.to_hash.to_json
  rescue => e
    STDERR.puts e
    @mes = {:error => e.to_s}.to_json
  end
end

get '/' do
  @pages = Page.all.desc(:time)
  haml :index
end

get '/*/show' do
  name = params[:splat].first
  begin
    unless @page = Page.where(:name => name).first
      status 404
    else
      haml :page
    end
  rescue => e
    STDERR.puts e
  end
end

get '/*' do
  name = params[:splat].first
  begin
    unless page = Page.where(:name => name).first
      status 404
    else
      redirect page.url
    end
  rescue => e
    STDERR.puts e
    status 500
  end
end
