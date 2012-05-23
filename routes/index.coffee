###
 GET home page.
###

fs = require('fs')
path = require('path')

UPLOAD_BASEPATH = './public/upload/'

exports.project = (req, res) ->
  project = req.params.project
  console.log("project:#{project}")
  if project.indexOf("favicon.ico") >= 0
      console.log("favicon")
      res.send("")
  else
    upPath = path.normalize(UPLOAD_BASEPATH + project);
    console.log(upPath)
    if not path.existsSync(upPath)
      res.render('index',{title:project, images:[]})
    else
      fs.readdir(upPath, (error, files) ->
        images = []
        for name in files
          if name.indexOf(".") != 0
            console.log("hoge")
            images.push "upload/#{project}/#{name}"
        console.log("files:#{images}")
        res.render('index',{title:project, images:images})
      )


exports.upload = (req, res) ->
  console.log("upload")
  upfile = req.files.upfile
  project = req.params.project
  upPath = path.normalize(UPLOAD_BASEPATH + project);
  if upfile?.size != 0
    console.log(upfile)
    if not path.existsSync(upPath)
      fs.mkdirSync(upPath)
    suffix = upfile.name.split(".").pop()
    fs.renameSync(upfile.path, upPath + "/" + new Date().getTime() + "." + suffix )
  res.redirect("/#{project}")