# bottle_seesion_login_logout_no_cache

Note that every page that uses a session should have the headers set to disable caching

  response.set_header("Cache-Control", "no-cache, no-store, must-revalidate")
  response.add_header("Pragma", "no-cache")
  
  # Delete the cookies from the browser
  # user_session_id was set at login, so destroy it
  response.set_cookie("user_session_id", "", expires=0)
