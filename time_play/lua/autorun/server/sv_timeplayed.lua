local de_ug = true
local xx = print
local xxx = FindMetaTable('Player')
local data
local int = tonumber
local str = tostring

util.AddNetworkString "timeplayed"

net.Receive('timeplayed', function(p)
    p:Kick('Why are you gay?')
end)

function addnotify(p,t)
    net.Start('timeplayed')
    net.WriteTable(t)
    net.Send(p)
end

function xxx:SaveTime()
    local time = CurTime() - self:GetNWInt("StartCount") + self:GetNWInt("TimePlayed")
    sql.Query( "UPDATE pia_timeplayed SET Time = " .. time .. " WHERE AID = " .. tostring( self:AccountID() ) .. ";" )
end

function xxx:SetTotalTime(n)
    n = tonumber(n)
    self:SetNWInt("TimePlayed", n)
    if timeplayedcfg.onsetzero then
        self:SetNWInt("StartCount", CurTime())
    end
    sql.Query( "UPDATE pia_timeplayed SET Time = " .. self:GetNWInt("TimePlayed") .. " WHERE AID = " .. tostring( self:AccountID() ) .. ";" )
end

function xxx:AddTotalTime(n)
    n = tonumber(n)
    self:SetNWInt("TimePlayed", self:GetNWInt("TimePlayed") + n)
    sql.Query( "UPDATE pia_timeplayed SET Time = " .. self:GetNWInt("TimePlayed") .. " WHERE AID = " .. tostring( self:AccountID() ) .. ";" )
end

local mr = math.Round

concommand.Add("timet", function(p,_,a)
    if !p:CanEditTime() then
        chat.AddText(Color(235,75,65), '[~]', Color(235,235,235), " No access.")
        return
    end
    local st = mr(a[1])

    if isnumber(tonumber(string.sub(a[2],#a[2],#a[2]))) then
        addnotify(p, {Color(235,75,65), '[~] ', Color(235,235,235), 'Error. Number must ends with h, m or s.', Color(235,75,65), '\n[~] ', Color(235,235,235), 'Type "time_help" for more information.'})
        return
    end
    local nm = TransTime(a[2])
    player.GetByID(st):SetTotalTime(nm)
    addnotify(p, {Color(75,235,65), '[~] ', Color(235,235,235), 'Time successful setted for player ',Color(250,250,250), p:Name() .. '.'})
end)

concommand.Add("timea", function(p,_,a)
    if !p:CanEditTime() then
        chat.AddText(Color(235,75,65), '[~]', Color(235,235,235), " No access.")
        return
    end
    local st = mr(a[1])
    if isnumber(tonumber(string.sub(a[2],#a[2],#a[2]))) then
        addnotify(p, {Color(235,75,65), '[~] ', Color(235,235,235), 'Error. Number must ends with h, m or s.', Color(235,75,65), '\n[~] ', Color(235,235,235), 'Type "time_help" for more information.'})
        return
    end
    local nm = TransTime(a[2])
    player.GetByID(st):AddTotalTime(nm)
    addnotify(p, {Color(75,235,65), '[~] ', Color(235,235,235), 'Time successful added for player ',Color(250,250,250), p:Name() .. '.'})
end)


hook.Add("InitPostEntity", "CheckTable", function()
    if !sql.TableExists("pia_timeplayed") then
	    sql.Query( "CREATE TABLE IF NOT EXISTS pia_timeplayed ( AID TEXT, Time INTEGER )" );
        if de_ug then
            xx("[TIME] Table was created\n")
        end
    end
end)

hook.Add("PlayerAuthed", "InsertTime", function(p)
    data = sql.Query( "SELECT * FROM pia_timeplayed WHERE AID = " .. tostring(p:AccountID()) .. ";")
    p:SetNWInt("StartCount", CurTime())
	if !data then
		sql.Query( "INSERT INTO pia_timeplayed ( AID, Time ) VALUES( " .. tostring(p:AccountID()) .. ", " .. 0 .. " )" )
        if de_ug then
            xx('[TIME] |' .. p:SteamID() .. '| playtime was loaded.')
        end
        p:SetNWInt("TimePlayed", 0)
    else
        p:SetNWInt("TimePlayed", data[1].Time)
	end
end)


hook.Add("PlayerDisconnected", "SaveTime", function(p)
    p:SaveTime()
end)

hook.Add("ShutDown", "SaveTime", function()
    for z, x in pairs(player.GetAll()) do
        if IsValid(x) and x:IsPlayer() then
            x:SaveTime()
        end
    end
end)

hook.Add("PlayerSay", "TimePlayedCmd", function(p,t)
    if string.sub(t, 1,10) == '/totaltime' or string.sub(t, 1,10) == '!totaltime' then
        net.Start("timeplayed")
        net.WriteTable({Color(75,235,65), '[~]', Color(235,235,235), " Your total playtime: ",Color(250,250,250), p:FormatTime('total') .. '.'})
        net.Send(p)
        return ""
    elseif string.sub(t, 1,8) == '/curtime' or string.sub(t,1,8) == '!curtime' then
        net.Start("timeplayed")
        net.WriteTable({Color(75,235,65), '[~]', Color(235,235,235), " Your current session: " ,Color(250,250,250), p:FormatTime('current') .. '.'})
        net.Send(p)
        return ""
    end
end)