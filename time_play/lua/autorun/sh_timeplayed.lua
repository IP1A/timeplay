timeplayedcfg = {}

timeplayedcfg.admintbl = {
    ['superadmin'] = true;
    ['admin'] = false
}

timeplayedcfg.steamidtbl = {
    ['STEAM_0:1:36843180'] = true; // Yeap that's me. You probably wondering...
}

timeplayedcfg.onsetzero = true // When someone sets the player's time, his current session will be reset to zero

local PLAYER = FindMetaTable("Player")

function FormatTime(t)
    t = string.FormattedTime(t)
    t = {['d'] = t.h, ['a'] = t.m, ['b'] = t.s}
    t_ = ""
    for z, x in pairs(t) do
        x = tostring(x)
        if x:len() > 1 then
            t_ = t_ .. x .. ":"
        else
            t_ = t_ .. '0' .. x .. ":"
        end
    end
    return t_:sub(1,#t_-1)
end

function PLAYER:FormatTime(n)
    n = n:lower()
    if n == 'total' then
        return FormatTime(self:GetTotalTimePlayed())
    elseif n == 'current' then
        return FormatTime(self:GetCurTimePlayed())
    end
end

function PLAYER:GetTotalTimePlayed()
    return CurTime() - self:GetNWInt("StartCount") + self:GetNWInt("TimePlayed")
end

function PLAYER:GetCurTimePlayed()
    return CurTime() - self:GetNWInt("StartCount")
end

function PLAYER:CanEditTime()
    return timeplayedcfg.admintbl[self:GetUserGroup()] or timeplayedcfg.steamidtbl[self:SteamID()] or self:IsSuperAdmin() or self:IsRoot()
end


local function AC1( cmd, stringargs )	
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	
	local tbl = {}
	
	for k, v in ipairs(player.GetAll()) do
		local nick = v:Nick()
		if string.find( string.lower( nick ), stringargs ) then
			nick = "\"" .. nick .. "\""
			nick = "time_set " .. nick
			
			table.insert(tbl, nick)
		end
	end
	
	return tbl
end
local function AC2( cmd, stringargs )	
	stringargs = string.Trim( stringargs )
	stringargs = string.lower( stringargs )
	
	local tbl = {}
	
	for k, v in ipairs(player.GetAll()) do
		local nick = v:Nick()
		if string.find( string.lower( nick ), stringargs ) then
			nick = "\"" .. nick .. "\""
			nick = "time_add " .. nick
			
			table.insert(tbl, nick)
		end
	end
	
	return tbl
end

function TransTime(n)
    local a = string.sub(n,#n,#n)
    n = math.Round(string.sub(n,1,#n-1))
    if a == 'm' then
        return n*60
    elseif a == 's' then
        return n
    elseif a == 'h' then
        return n * 3600
    end
end

concommand.Add('time_set', function(p,_,a)
    if !p:CanEditTime() then
        chat.AddText(Color(235,75,65), '[~]', Color(235,235,235), " No access.")
        return
    end
    for z, x in pairs(player.GetAll()) do
        if x:Name() == a[1] then
            RunConsoleCommand('timet', x:EntIndex(), a[2])
            return
        end
    end
end,AC1)

concommand.Add('time_add', function(p,_,a)
    if !p:CanEditTime() then
        chat.AddText(Color(235,75,65), '[~]', Color(235,235,235), " No access.")
        return
    end
    for z, x in pairs(player.GetAll()) do
        if x:Name() == a[1] then
            RunConsoleCommand('timea', x:EntIndex(), a[2])
            return
        end
    end
end,AC2)

concommand.Add("time_help",function(p,_,a)
    chat.AddText('\n')
    chat.AddText(Color(235,135,65), '[~]', Color(235,235,235), "To set player " .. 'time use:\n time_set "Name" "number"')
    chat.AddText(Color(235,135,65), '[~]', Color(235,235,235), "To add player " .. 'time use:\n time_add "Name" "number"')
    chat.AddText(Color(235,135,65), '[~]', Color(235,235,235), "The number must ends with:")
    chat.AddText(Color(235,135,65), '', Color(235,235,235), "s - to convert to seconds.")
    chat.AddText(Color(235,135,65), '', Color(235,235,235), "m - to convert to minutes.")
    chat.AddText(Color(235,135,65), '', Color(235,235,235), "h - to convert to hours.")
    chat.AddText(Color(235,135,65), '[~]', Color(235,235,235), "So it'll looks like:")
    chat.AddText(Color(235,135,65), '', Color(235,235,235), 'time_set "'.. p:Name() .. '" "1337h"')
end)