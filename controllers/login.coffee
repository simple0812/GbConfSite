User = require "#{$WEBPATH}/models/user"

passport.use(new LocalStrategy((username,password,done) ->
  User.find {userName:username,password:password},(err, docs) ->
    return done err if err?
    return done null,false,{message:"用户名或者密码错误"} if docs.length is 0
    done null,docs[0]))

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (user, done) ->
  done null, user

app.get '/login',(req, res) ->
  res.render 'login', layout:false, error:req.flash('error')

app.post('/login',
  passport.authenticate('local',
    {
      failureRedirect: '/login',
      failureFlash:true
    }
  ),
  (req,res) ->
    if req.user.role is 'normal' #普通用户
      res.redirect '/MB/index'
    else if req.user.role is 'auditor' #审核员
      res.redirect '/audit'
    else if req.user.role is 'admin' #管理员
      res.redirect '/BM/index'
)
app.get '/logout', (req, res) ->
  req.logout()
  (res.clearCookie k) for k,v of req.cookies
  res.redirect('/')

global.authenticateCheck = (req,res,next) ->
  if req.isAuthenticated()
    if req.user?
      res.cookie "userid", req.user._id or ''
      res.cookie "username", req.user.username or ''
      res.cookie "nickname", req.user.name or ''
      res.cookie "usertype", req.user.role or ''
    next()
  else
    res.redirect('/login')
