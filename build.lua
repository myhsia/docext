--[==========================================================================[--
    L3BUILD FILE FOR DOCEXT                      Copyright (C) by Mingyu Xia
--]==========================================================================]--

--[==========================================================================[--
    Basic Information: Do Check Before Push
--]==========================================================================]--
module              = "docext"
version             = "v0.2C"
date                = "2026-07-01"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/" .. module
summary             = "Extension for documenting the LaTeX source files"
description         = "The `docext` package is an extension for documenting the LaTeX source files."

--[==========================================================================[--
    Configuration: Check, Tag, Pack, Upload     Do NOT Modify if Unnecessary
--]==========================================================================]--
checkengines        = {"pdftex", "xetex", "uptex", "luatex"}
cleanfiles          = {"*.log", "*.pdf", "*.zip", "*.curlopt"}
ctanzip             = module
excludefiles        = {"*~"}
textfiles           = {"README.md", "LICENSE", "*.lua"}
typesetexe          = "latexmk -pdf -pdflatex=pdflatex-dev"
typesetruns         = 1
uploadconfig  = {
  note              = "",
  announcement_file = "announcement.md",
  pkg               = module,
  version           = version .. " " .. date,
  author            = maintainer,
  uploader          = uploader,
  email             = email,
  summary           = summary,
  description       = description,
  license           = "lppl1.3c",  
  ctanPath          = "/macros/latex/contrib/" .. module,
  home              = "",
  bugtracker        = repository .. "/issues",
  support           = repository .. "/issues",
  repository        = repository,
  development       = "https://github.com/" .. maintainid,
  update            = true
}
function update_tag(file, content, tagname, tagdate)
  tagname = version
  tagdate = date
  if string.match(file, module .. ".dtx$") then
    content = string.gsub(content,
      "%%<%+!driver>\\GetIdInfo $Id: " .. module .. ".dtx " ..
      "v%d+%.%d+%a+ %d+%-%d+%-%d+ (.-)<(.-)>",
      "%%<+!driver>\\GetIdInfo $Id: "  .. module .. ".dtx " ..
      tagname .. " " .. tagdate .. " " .. maintainid .. "<" .. email .. ">")
  end
  return content
end

--[================== "Hacks" to `l3build` | Do not Modify ==================]--
function docinit_hook()
  cp(ctanreadme, unpackdir, currentdir)
  return 0
end
function tex(file,dir,cmd)
  dir = dir or "."
  cmd = cmd or typesetexe
  if os.getenv("WINDIR") ~= nil or os.getenv("COMSPEC") ~= nil then
    upretex_aux = "-usepretex=\"" .. typesetcmds .. "\""
    makeidx_aux = "-e \"$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\""
    sandbox_aux = "set \"TEXINPUTS=../local;%TEXINPUTS%;\" &&"
  else
    upretex_aux = "-usepretex=\'" .. typesetcmds .. "\'"
    makeidx_aux = "-e \'$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\'"
    sandbox_aux = "TEXINPUTS=\"../local:$(kpsewhich -var-value=TEXINPUTS):\""
  end
  return run(dir, sandbox_aux .. " " .. cmd         .. " " ..
                  upretex_aux .. " " .. makeidx_aux .. " " .. file)
end
