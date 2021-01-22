#!/usr/bin/env node
var config = require("./configs.js");
var handlebars = require('handlebars');
var fs = require('fs');
var moment = require("moment");
const path = require('path');


// 向handlebars中注册{{date}}函数调用标签
handlebars.registerHelper('date', function (items, options) {
  var time = moment().format("YYYY/M/d")
  return new handlebars.SafeString(time)
});

handleTemplate("templates/HD{{Module}}ViewModel.swift")


// 生成源码，传入templatefile为模板文件路径
function handleTemplate(templatefile) {
  var source = fs.readFileSync(templatefile, "utf8");
  var template = handlebars.compile(source);
  var result = template(config)
  console.log(result)

  var templateDir = "templates/"
  var targetDir = "targetDir"

  // 将路径中的标签替换为配置中的变量值作为保存路径
  var saveFilePath = templatefile.replace(new RegExp(templateDir, 'g'), "")
  console.log(saveFilePath)
  console.log("===")

  saveFilePath = saveFilePath.replace(/{{Module}}/g, config.Module)
  console.log(saveFilePath)
  console.log("===")

  var filePath = path.join(targetDir, saveFilePath)
  console.log("生成:" + filePath)
  fs.writeFile(filePath, result, function (e) {
    if (e) {
      console.log("error: " + result.name + " : " + e);
    }
  });
}

