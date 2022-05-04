script_name("AutoGoPrize")
script_author("Dashok.")
script_version('1.2')

require("lib.moonloader")

local sampev = require "lib.samp.events"
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local imgui = require('imgui')
local inicfg = require 'inicfg'
local sw, sh = getScreenResolution()
local ini = inicfg.load({
    setting = 
    {
      delayTime = ""
    }
})

local main_window = imgui.ImBool(false)
local buffer_time = imgui.ImBuffer(200)

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function theme_white() -- Rice Style
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    
    colors[clr.Text]                   = ImVec4(0.01, 0.36, 1.00, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.00, 0.60, 0.67, 0.97);
    colors[clr.WindowBg]               = ImVec4(0.02, 0.00, 0.06, 1.00);
    colors[clr.ChildWindowBg]          = ImVec4(0.09, 0.01, 0.15, 0.26);
    colors[clr.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 1.00);
    colors[clr.Border]                 = ImVec4(0.07, 0.10, 0.15, 0.56);
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.49);
    colors[clr.FrameBg]                = ImVec4(0.06, 0.19, 0.46, 0.29);
    colors[clr.FrameBgHovered]         = ImVec4(0.03, 0.00, 0.06, 0.22);
    colors[clr.FrameBgActive]          = ImVec4(0.00, 0.00, 0.00, 0.10);
    colors[clr.TitleBg]                = ImVec4(0.01, 0.01, 0.05, 1.00);
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.26, 0.55, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.40, 0.40, 0.90, 0.20);
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.00, 0.00, 0.80);
    colors[clr.ScrollbarBg]            = ImVec4(0.27, 0.00, 1.00, 0.19);
    colors[clr.ScrollbarGrab]          = ImVec4(0.00, 1.00, 0.95, 0.30);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.00, 0.00, 0.00, 0.40);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.02, 0.98, 1.00, 0.40);
    colors[clr.ComboBg]                = ImVec4(0.00, 0.00, 0.00, 0.99);
    colors[clr.CheckMark]              = ImVec4(0.00, 0.58, 1.00, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.30);
    colors[clr.SliderGrabActive]       = ImVec4(0.80, 0.50, 0.50, 1.00);
    colors[clr.Button]                 = ImVec4(0.09, 0.06, 0.20, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(0.08, 0.03, 0.21, 0.27);
    colors[clr.ButtonActive]           = ImVec4(0.00, 0.54, 1.00, 1.00);
    colors[clr.Header]                 = ImVec4(0.35, 0.02, 1.00, 0.45);
    colors[clr.HeaderHovered]          = ImVec4(0.06, 0.39, 0.40, 0.80);
    colors[clr.HeaderActive]           = ImVec4(0.00, 0.86, 1.00, 0.80);
    colors[clr.Separator]              = ImVec4(0.07, 0.30, 0.52, 1.00);
    colors[clr.SeparatorHovered]       = ImVec4(0.00, 0.00, 0.00, 1.00);
    colors[clr.SeparatorActive]        = ImVec4(0.06, 0.06, 0.90, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(0.02, 0.01, 0.27, 0.30);
    colors[clr.ResizeGripHovered]      = ImVec4(0.24, 0.00, 0.87, 0.60);
    colors[clr.ResizeGripActive]       = ImVec4(0.00, 0.00, 0.00, 0.90);
    colors[clr.CloseButton]            = ImVec4(0.00, 0.00, 0.00, 0.90);
    colors[clr.CloseButtonHovered]     = ImVec4(1.00, 0.16, 0.00, 0.26);
    colors[clr.CloseButtonActive]      = ImVec4(1.00, 0.05, 0.05, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.45, 0.00, 0.73, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(0.07, 0.02, 0.39, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(0.06, 0.05, 0.12, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(0.10, 0.06, 0.27, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(0.17, 0.06, 0.41, 0.35);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.28, 0.05, 0.59, 0.35);
end
theme_white()

function imgui.OnDrawFrame()
    if main_window.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Íàñòðîéêè')
    if imgui.InputText(u8"Çàäåðæêà (ìñ)", buffer_time) then
    ini.setting.delayTime = buffer_time.v
      inicfg.save(ini)
    end
    imgui.Text("")
    imgui.CenterText(u8"Çà ñåññèþ âû ïîëó÷èëè: ")
    imgui.CenterText(u8"Çà âñå âðåìÿ âû ïîëó÷èëè: ")

    if imgui.Button(u8"Çàêðûòü") then
        main_window.v = false
    end
    imgui.SameLine()
    if imgui.Button(u8"Reload") then
      thisScript():reload()
    end
    imgui.SameLine()
    if imgui.Button(u8"Âûêëþ÷èòü") then
      thisScript():unload()
    end

    imgui.End() 
    end
end

function msg(text)
    sampAddChatMessage("{9966FF}[AutoGoPrize]: "..text)
end

function sampev.onServerMessage(color, text)
    local ptr = "ÐÀÇÄÀ×À ÇÀÏÓÙÅÍÀ!"
    if text:find(ptr) then
        sampSendChat("/goprize")
    end
end

function sampev.onShowDialog(dialogid, style, title, b1, b2, text)

text = text:gsub("{......}", "")
local pattern = "Ââåäèòå äàííûé êîä â ïîëå âíèçó: (.+)"
if text:find(pattern) then
     lua_thread.create(function()
    local n1 = text:match(pattern)
    wait(ini.setting.delayTime)
    sampSendDialogResponse(7987, 1, 0, ""..n1)
    wait(300)
    sampCloseCurrentDialogWithButton(0)
     end)
end

if dialogid == 7986 then
    local count = -1
    for line in text:gmatch("[^\n]+") do
        count = count + 1
        if line:find("Ïîëó÷èòü ïðèç") then
             sampSendDialogResponse(dialogid, 1, count, -1)
             break
        end
    end
end
end

function sets()
    main_window.v = not main_window.v
end
function main()
    while not isSampAvailable() do wait(0) end
    main_window.v = false
   
    buffer_time.v = ini.setting.delayTime

   msg("Çàãðóæåí")
   msg("Autor: Dashok.")
   msg("Àêòèâàöèÿ - Àâòîìàòè÷åñêàÿ")

   sampRegisterChatCommand("g.set",sets)

   update()
    while true do
        wait(0)
        imgui.Process = main_window.v
    end
end




local dlstatus = require('moonloader').download_status
function update()

  local fpath = os.getenv('TEMP') .. '\\testing_version.json' 
  downloadUrlToFile('https://raw.githubusercontent.com/dashooook/scriptsRDS/main/update.json', fpath, function(id, status, p1, p2) 
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') 
    if f then
      local info = decodeJson(f:read('*a')) 
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) 
        if version > tonumber(thisScript().version) then 
          lua_thread.create(goupdate) 
        else 
          update = false 
          msg('Ó âàñ è òàê ïîñëåäíÿÿ âåðñèÿ ñêðèïòà! Îòìåíÿþ îáíîâëåíèå.')
        end
      end
    end
  end
end)
end

function goupdate()
msg('Îáíàðóæåíî íîâîå îáíîâëåíèå')
msg('Òåêóùàÿ âåðñèÿ: '..thisScript().version.." Íîâàÿ âåðñèÿ: "..version)
wait(3000)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  wait(3000)
  msg('Îáíîâëåíèå çàâåðøåíî!')
  msg('Îçíàêîìèòñÿ ñ íèì ìîæíî â ãðóïïå ñêðèïòà')
  wait(4000)
  thisScript():reload()
end
end)
end


