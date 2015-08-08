module ViewHelpers
  def greetings
    if session.has_key? :user
      haml :_logged_in, locals: { name: session[:user].full_name }
    else
      haml :_login
    end
  end
end
