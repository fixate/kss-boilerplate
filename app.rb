require 'sinatra'
require 'kss'
require 'coffee_script'

get '/' do
  erb :index
end

get '/styleguide' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :styleguide
end

get '/alerts' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :alerts
end

get '/base' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :base
end

get '/buttons' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :buttons
end

get '/color' do
  @styleguide = Kss::Parser.new('public/spec')
	@use_kss_spec = true
  erb :color
end

get '/forms' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :forms
end

get '/gallery' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :gallery
end

get '/grid' do
  @styleguide = Kss::Parser.new('public/spec')
	@use_kss_spec = true
  erb :grid
end

get '/nav' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :nav
end

get '/progress' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :progress
end

get '/text-variations' do
  @styleguide = Kss::Parser.new('public/spec')
  erb :text_variations
end

get '/tool-tips' do
  @styleguide = Kss::Parser.new('public/spec')
	@scripts = ['//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js',
						 '//cdnjs.cloudflare.com/ajax/libs/qtip2/2.2.0/jquery.qtip.min.js',
						 '/js/tool_tips.js']
  erb :tool_tips
end

# if a coffee file exists for a js request, use the coffee file
#
# http://jaketrent.com/post/serve-coffeescript-with-sinatra/ or
# http://railscoder.com/setting-up-sinatra-to-use-slim-sass-and-coffeescript/
["/js/*.js", "/assets/javascripts/*.js"].each do |path|
	get path do
		filename = params[:splat].first
		ext = !path[/assets/] ? '' : '.js'
		dir = File.dirname(path)
		coffee "../public#{dir}/#{filename}#{ext}".to_sym
	end
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

	# dynamically add stylesheets if the `get` block defines @use_kss_spec as true
	def get_spec
		@_out_buf << erb(:_spec_link) if @use_kss_spec
	end

	# use @scripts to define an array of scripts required on any particular page
	def get_scripts
		@scripts ||= []
		@scripts.each do |s|
			@script = s
			@_out_buf << erb(:_script_tag)
		end
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
