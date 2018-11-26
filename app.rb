require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"
require "combine_pdf"

#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil
def reached_limit?
	if session[:times_used].nil?
		return false
	else
		return session[:times_used] > 3
	end
end

def signed_in?
	return !current_user.nil?
end

def impose_limit!
	#need classes help
	flash[:error] = "Error: You have reached the free limit. Please <a href='/upgrade'>upgrade</a> to continue."
	redirect "/"
end

def load_file1
	if !params[:file1].nil?
		unloaded_file = params[:file1][:tempfile]
		loaded_file = unloaded_file.read
		return CombinePDF.parse(loaded_file)
	else
		return nil
	end
end

def load_file2
	if !params[:file2].nil?
		unloaded_file = params[:file2][:tempfile]
		loaded_file = unloaded_file.read
		return CombinePDF.parse(loaded_file)
	else
		return nil
	end
end

def load_file3
	if !params[:file3].nil?
		unloaded_file = params[:file3][:tempfile]
		loaded_file = unloaded_file.read
		return CombinePDF.parse(loaded_file)
	else
		return nil
	end
end

def load_file4
	if !params[:file4].nil?
		unloaded_file = params[:file4][:tempfile]
		loaded_file = unloaded_file.read
		return CombinePDF.parse(loaded_file)
	else
		return nil
	end
end

def increase_times_used
	if session[:times_used].nil?
		session[:times_used] = 1
	else
		session[:times_used] != 1
	end
end

get "/" do
	erb :index
end


post "/merge" do
	impose_limit!

	merged = CombinePDF.new

	cpdf1 = load_file1
	cpdf2 = load_file2
	cpdf3 = load_file3
	cpdf4 = load_file4

	merged << cpdf1 if !cpdf1.nil?
	merged << cpdf2 if !cpdf2.nil?
	merged << cpdf3 if !cpdf3.nil?
	merged << cpdf4 if !cpdf4.nil?

	increase_times_used

	status 200
	headers 'content-type' => "application/pdf"
	body merged.to_pdf
end