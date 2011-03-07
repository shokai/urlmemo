#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

before do
  @title = 'urlmemo'
end

get '/add' do
  @page_url = params['url']
  @page_url = 'http://' if !@page_url or @page_url.size < 1
  @page_title = params['title']
  @page_title = '(no title)' if !@page_title or @page_title.size < 1
  haml :add
end

get '/api' do
  @title += ' API'
  haml :api
end

post '/' do
  name = params['name']
  url = params['url']
  title = params['title']
  begin
    raise Err.new 'url and title required' if !url or url.size < 1 or !title or title.size < 1
    raise Err.new 'invalid url' unless url =~ /https?:\/\/.+/
    if tmp = Page.where(:url => url).first
      @mes = tmp.to_hash.to_json
    else
      page = Page.new(:url => url, :time => Time.now.to_i, :title => title)
      if !name or name.size < 1
        if last = Page.where(:name => /[1-9][0-9]*/).map{|i|i.name.to_i}.max
          page.name = (last+1).to_s
        else
          page.name = 1.to_s
        end
      else
        name.gsub!('/','')
        raise Err.new('invalid name') if routed?("/#{name}")
        raise Err.new('page already exists') if Page.where(:name => name).count > 0
        page.name = name
      end
      page.save
      @mes = page.to_hash.to_json
    end
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
      @title += ' '+@page.title
      haml :page
    end
  rescue => e
    STDERR.puts e
  end
end

get '/*/delete' do
  name = params[:splat].first
  begin
    Page.where(:name => name).delete
    redirect app_root
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

