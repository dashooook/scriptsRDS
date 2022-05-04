script_name("AutoGoPrize")
script_author("Dashok.")
script_version('1.3')

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

function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4
  style.WindowRounding = 2
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
  style.ChildWindowRounding = 2.0
  style.FrameRounding = 3
  style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.GrabMinSize = 8.0
  style.GrabRounding = 1.0
  style.WindowPadding = imgui.ImVec2(4.0, 4.0)
  style.FramePadding = imgui.ImVec2(3.5, 3.5)
  style.ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
  colors[clr.WindowBg]              = ImVec4(0.14, 0.12, 0.16, 1.00);
  colors[clr.ChildWindowBg]         = ImVec4(0.30, 0.20, 0.39, 0.00);
  colors[clr.PopupBg]               = ImVec4(0.05, 0.05, 0.10, 0.90);
  colors[clr.Border]                = ImVec4(0.89, 0.85, 0.92, 0.30);
  colors[clr.BorderShadow]          = ImVec4(0.00, 0.00, 0.00, 0.00);
  colors[clr.FrameBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
  colors[clr.FrameBgHovered]        = ImVec4(0.41, 0.19, 0.63, 0.68);
  colors[clr.FrameBgActive]         = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.TitleBg]               = ImVec4(0.41, 0.19, 0.63, 0.45);
  colors[clr.TitleBgCollapsed]      = ImVec4(0.41, 0.19, 0.63, 0.35);
  colors[clr.TitleBgActive]         = ImVec4(0.41, 0.19, 0.63, 0.78);
  colors[clr.MenuBarBg]             = ImVec4(0.30, 0.20, 0.39, 0.57);
  colors[clr.ScrollbarBg]           = ImVec4(0.30, 0.20, 0.39, 1.00);
  colors[clr.ScrollbarGrab]         = ImVec4(0.41, 0.19, 0.63, 0.31);
  colors[clr.ScrollbarGrabHovered]  = ImVec4(0.41, 0.19, 0.63, 0.78);
  colors[clr.ScrollbarGrabActive]   = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.ComboBg]               = ImVec4(0.30, 0.20, 0.39, 1.00);
  colors[clr.CheckMark]             = ImVec4(0.56, 0.61, 1.00, 1.00);
  colors[clr.SliderGrab]            = ImVec4(0.41, 0.19, 0.63, 0.24);
  colors[clr.SliderGrabActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.Button]                = ImVec4(0.41, 0.19, 0.63, 0.44);
  colors[clr.ButtonHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
  colors[clr.ButtonActive]          = ImVec4(0.64, 0.33, 0.94, 1.00);
  colors[clr.Header]                = ImVec4(0.41, 0.19, 0.63, 0.76);
  colors[clr.HeaderHovered]         = ImVec4(0.41, 0.19, 0.63, 0.86);
  colors[clr.HeaderActive]          = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.ResizeGrip]            = ImVec4(0.41, 0.19, 0.63, 0.20);
  colors[clr.ResizeGripHovered]     = ImVec4(0.41, 0.19, 0.63, 0.78);
  colors[clr.ResizeGripActive]      = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.CloseButton]           = ImVec4(1.00, 1.00, 1.00, 0.75);
  colors[clr.CloseButtonHovered]    = ImVec4(0.88, 0.74, 1.00, 0.59);
  colors[clr.CloseButtonActive]     = ImVec4(0.88, 0.85, 0.92, 1.00);
  colors[clr.PlotLines]             = ImVec4(0.89, 0.85, 0.92, 0.63);
  colors[clr.PlotLinesHovered]      = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.PlotHistogram]         = ImVec4(0.89, 0.85, 0.92, 0.63);
  colors[clr.PlotHistogramHovered]  = ImVec4(0.41, 0.19, 0.63, 1.00);
  colors[clr.TextSelectedBg]        = ImVec4(0.41, 0.19, 0.63, 0.43);
  colors[clr.ModalWindowDarkening]  = ImVec4(0.20, 0.20, 0.20, 0.35);
end
apply_custom_style()

function imgui.OnDrawFrame()
    if main_window.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 250), imgui.Cond.FirstUseEver)
    imgui.Begin(u8'Настройки')
    if imgui.InputText(u8"Задержка (мс)", buffer_time) then
    ini.setting.delayTime = buffer_time.v
      inicfg.save(ini)
    end
    imgui.Text("")
    imgui.CenterText(u8"За сессию вы получили: ")
    imgui.CenterText(u8"За все время вы получили: ")

    if imgui.Button(u8"Закрыть") then
        main_window.v = false
    end
    imgui.SameLine()
    if imgui.Button(u8"Reload") then
      thisScript():reload()
    end
    imgui.SameLine()
    if imgui.Button(u8"Выключить") then
      thisScript():unload()
    end

    imgui.End() 
    end
end

function msg(text)
    sampAddChatMessage("{FFCCFF}[AutoGoPrize]: {FFFF99}"..text)
end

function sampev.onServerMessage(color, text)
    local ptr = "РАЗДАЧА ЗАПУЩЕНА!"
    if text:find(ptr) then
        sampSendChat("/goprize")
    end
end

function sampev.onShowDialog(dialogid, style, title, b1, b2, text)

text = text:gsub("{......}", "")
local pattern = "Введите данный код в поле внизу: (.+)"
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
        if line:find("Получить приз") then
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

   msg("Загружен")
   msg("Autor: Dashok.")
   msg("Активация - Автоматическая")

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
          msg('У вас и так последняя версия скрипта! Отменяю обновление.')
        end
      end
    end
  end
end)
end

function goupdate()
msg('Обнаружено новое обновление')
msg('Текущая версия: '..thisScript().version.." Новая версия: "..version)
wait(3000)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  wait(3000)
  msg('Обновление завершено!')
  msg('Ознакомится с ним можно в группе скрипта')
  wait(4000)
  thisScript():reload()
end
end)
end


