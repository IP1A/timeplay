local tmd = CreateClientConVar("time_drawhud", 1, true, false)
local tmp = CreateClientConVar("time_hudpos", 1, true, false)

hook.Add( "PopulateToolMenu", "myHookClass", function()
	spawnmenu.AddToolMenuOption("Utilities", "PlayTime", "HUD", "HUD", "","",  function(panel)
        panel:ClearControls()
	
        panel:AddControl("Label", {Text = "HUD SETTINGS"})
        
        panel:AddControl("CheckBox", {Label = "Should draw hud?", Command = "time_drawhud"})
        panel:AddControl("Label", {Text = "HUD POS\n1 - TOP LEFT\n2 - TOP RIGHT\n3 - BOTTOM LEFT\n4 - BOTTOM RIGHT"})
        local slider = vgui.Create("DNumSlider", panel)
        slider:SetDecimals(0)
        slider:SetMin(1)
        slider:SetMax(4)
        slider:SetConVar("time_hudpos")
        slider:SetValue(GetConVarNumber("time_hudpos"))
        slider:SetText("POS")
        
        panel:AddItem(slider)
    end)
end )
local rgb = Color

local dtx = draw.SimpleTextOutlined

surface.CreateFont('time', {font = 'Roboto Light', size = 14, weight = 900, extended = true, antialias = true})
surface.CreateFont('times', {font = 'Roboto Light', size = 14, weight = 900, extended = true, antialias = true})

local tbl = {}
tbl[1] = {w = 5, h = 5}
tbl[2] = {w = ScrW(), h = ScrH()}
local w local h
hook.Add("HUDPaint", "MeinTime", function()
    if tmd:GetBool() then
        if tmp:GetInt() == 1 then
            dtx("Total Time Played", 'time', 5,5, rgb(47, 53, 66), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('total'), 'times', 5,25, rgb(250,250,250), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
            dtx("Current Session", 'time', 5,45, rgb(207, 203, 203), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('current'), 'times', 5,65, rgb(250,250,250), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
        elseif tmp:GetInt() == 2 then
            dtx("Total Time Played", 'time', ScrW()-5,5, rgb(47, 53, 66), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('total'), 'times', ScrW()-5,5+20, rgb(250,250,250), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx("Current Session", 'time', ScrW()-5,5+40, rgb(207, 203, 203), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('current'), 'times', ScrW()-5,5+60, rgb(250,250,250), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
        elseif tmp:GetInt() == 3 then
            dtx("Total Time Played", 'time', 5,ScrH()-65, rgb(47, 53, 66), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('total'), 'times', 5,ScrH()-50, rgb(250,250,250), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
            dtx("Current Session", 'time', 5,ScrH()-35, rgb(207, 203, 203), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('current'), 'times', 5,ScrH()-20, rgb(250,250,250), TEXT_ALIGN_LEFT, 0, .5, rgb(15,15,15,200))
        elseif tmp:GetInt() == 4 then
            dtx("Total Time Played", 'time', ScrW()-5,ScrH()-65, rgb(47, 53, 66), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('total'), 'times', ScrW()-5,ScrH()-50, rgb(250,250,250), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx("Current Session", 'time', ScrW()-5,ScrH()-35, rgb(207, 203, 203), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('current'), 'times', ScrW()-5,ScrH()-20, rgb(250,250,250), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
        else
            dtx("Total Time Played", 'time', ScrW()-5,5, rgb(47, 53, 66), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('total'), 'times', ScrW()-5,5+20, rgb(250,250,250), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx("Current Session", 'time', ScrW()-5,5+40, rgb(207, 203, 203), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
            dtx(LocalPlayer():FormatTime('current'), 'times', ScrW()-5,5+60, rgb(250,250,250), TEXT_ALIGN_RIGHT, 0, .5, rgb(15,15,15,200))
        end
    end
end)


net.Receive('timeplayed', function()
    chat.AddText(unpack(net.ReadTable()))
end)