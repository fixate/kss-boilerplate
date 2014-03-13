require 'sinatra'
require 'kss'

get '/' do
  erb :index
end

get '/styleguide' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :styleguide
end

get '/alerts' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :alerts
end

get '/base' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :base
end

get '/buttons' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :buttons
end

get '/color' do
  @styleguide = Kss::Parser.new('public/stylesheets')
	@use_kss_stylesheet = true
  erb :color
end

get '/forms' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :forms
end

get '/gallery' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :gallery
end

get '/grid' do
  @styleguide = Kss::Parser.new('public/stylesheets')
	@use_kss_stylesheet = true
  erb :grid
end

get '/nav' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :nav
end

get '/progress-bars' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :progress_bars
end

get '/text-variations' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :text_variations
end

get '/tool-tips' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :tool_tips
end

helpers do
  # Generates a styleguide block. A little bit evil with @_out_buf, but
  # if you're using something like Rails, you can write a much cleaner helper
  # very easily.
  def styleguide_block(section, show_example = true, show_escaped = true, &block)
    @section = @styleguide.section(section)
		@show_example = show_example
		@show_escaped = show_escaped
    @example_html = capture{ block.call }
    @escaped_html = ERB::Util.html_escape @example_html
    @_out_buf << erb(:_styleguide_block)
  end

	# dynamically add stylesheets if the `get` block defines @use_kss_stylesheet as true
	def get_stylesheets
		@_out_buf << erb(:_stylesheet_link) if @use_kss_stylesheet
	end

  # Captures the result of a block within an erb template without spitting it
  # to the output buffer.
  def capture(&block)
    out, @_out_buf = @_out_buf, ""
    yield
    @_out_buf
  ensure
    @_out_buf = out
  end
end
