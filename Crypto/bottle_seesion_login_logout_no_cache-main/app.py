from flask import Flask, request, redirect, session,render_template
from flask_session import Session
import flask_login
import flask
import hashlib
import uuid
from datetime import datetime as dt
import datetime


# REDIS, MYSQL/MARIADB, SQLITE, MONGODB
users = [
  { 
    "id":"1", 
    "name":"001", 
    "username":"player1",
    "password":"aec8c38892d150b8dafe0dc055a7d0f1f9bf0b44388f033505b0c2164b77f645d884d4b4818b79b5578b3a919046676da14954b03b81d61cd16318cc3f1778e1" ,
    #"password":"pass1" ,
    "salt":"cB3Tz"
  },
  { 
    "id":"2", 
    "name":"002", 
    "username":"player2",
    "password":"058b9f88d7c9ea0cd569372f3a331fa402f9f65f80f89d7a7a6dbf684d51ea1616f8d62226a3e723576223e5278b4864b3395d383a31bc8b1d12cefc2ceffe2f" ,
    #"password":"pass2",
    "salt":"y6YdV"
  },  
]

sessions = {}
session_list = {}

#something need global var
data = {
  "name" : "",
  "username" : "",
  "RealPasss" : "",
  "hash" : "",
  "session_value" : ""
}



app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

@app.before_request
def before_request():
    flask.session.permanent = True
    app.permanent_session_lifetime = datetime.timedelta(minutes=5)
    flask.session.modified = True
    flask.g.user = flask_login.current_user

@app.route("/")
def index():
  print("Session LIST",session_list)
  if data["session_value"] == "":
      return redirect("/login")
  return redirect("/admin")

@app.route("/login", methods=["POST", "GET"])
def login():
  if request.method == "POST":
    session["name"] = request.form.get("user_username")
    #print("session list")
    #print(sessions)
    #print("END session list")
    print("*"*30)
    #print(session["name"])
    user_username = request.form.get("user_username")
    user_password = request.form.get("user_password")
    password = user_password
    for user in users:
      if user_username == user["username"] :
        user_password = user_password + user["salt"]
        user_password = hashlib.sha512(user_password.encode())
        if user_password.hexdigest() == user["password"]:
          if user_username not in session_list: #first login
            user_session_id = str(uuid.uuid4())
            sessions[user_session_id] = user
            session_list[user_username] = user_session_id
          else:
            #print(sessions)
            #print(session_list)
            #print(session_list[user_username])
            user_session_id = session_list[user_username]
          print("#"*30)
          print(user_session_id)
          print("#"*30)
          print(sessions)
          print("#"*30)
          print(session_list)
          print("#"*30)
          data["name"] = user["name"]
          data["username"] = user_username
          data["RealPasss"] = password
          data["hash"] = user["password"]
          data["session_value"] = user_session_id
          return redirect('/admin')
    return  render_template('index.html')
  return render_template('login.html')


@app.route("/admin")
def admin():
  now = dt.now() # current date and time
  time = now.strftime("%H:%M:%S")
  return render_template('admin.html',
                          name = data["name"],
                          username = data["username"],
                          password = data["RealPasss"],
                          #salt = user["salt"],
                          hash = data["hash"],
                          sessions = data["session_value"],
                          timestamp = time)

@app.route("/logout")
def logout():
  print("logout click")
  session_list = {}
  session["name"] = None
  data["name"] = ""
  data["username"] = ""
  data["RealPasss"] = ""
  data["hash"] = ""
  data["session_value"] = ""
  print("Session LIST Logout",session_list)
  return redirect('/')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=81)

