-- ======================================================
-- ✅ Custom Access Control by Miracle Kaligis (mrclxgis)
-- ======================================================

local OwnerUsername = "mrclxgis"
local AuthorizedPlayers = { [OwnerUsername] = true }

local AccessFile = "AuthorizedPlayers.txt"

if isfile and isfile(AccessFile) then
    local data = readfile(AccessFile)
    for name in string.gmatch(data, "[^,\n]+") do
        AuthorizedPlayers[name] = true
    end
end

local function SaveAccessList()
    if writefile then
        local list = {}
        for name in pairs(AuthorizedPlayers) do
            table.insert(list, name)
        end
        writefile(AccessFile, table.concat(list, ","))
    end
end

local function HasAccess(player)
    return AuthorizedPlayers[player.Name] == true or player.Name == OwnerUsername
end

cmd = cmd or {}

cmd.addaccess = function(plr, args)
    if plr.Name ~= OwnerUsername then
        return DoNotif("Kamu bukan pemilik utama, akses ditolak!", 5)
    end
    local target = args[1]
    if not target then
        return DoNotif("Gunakan: ;addaccess <username>", 5)
    end
    AuthorizedPlayers[target] = true
    SaveAccessList()
    DoNotif("✅ " .. target .. " sekarang punya akses admin.", 5)
end

cmd.removeaccess = function(plr, args)
    if plr.Name ~= OwnerUsername then
        return DoNotif("Kamu bukan pemilik utama, akses ditolak!", 5)
    end
    local target = args[1]
    if not target then
        return DoNotif("Gunakan: ;removeaccess <username>", 5)
    end
    AuthorizedPlayers[target] = nil
    SaveAccessList()
    DoNotif("❌ " .. target .. " dihapus dari daftar akses.", 5)
end

cmd.listaccess = function(plr)
    if not HasAccess(plr) then
        return DoNotif("Kamu tidak punya izin untuk melihat daftar akses.", 5)
    end
    local list = {}
    for name in pairs(AuthorizedPlayers) do
        table.insert(list, name)
    end
    DoWindow("🔑 Authorized Players:\n" .. table.concat(list, "\n"))
end

local oldCMDRun = cmd.run or function() end
cmd.run = function(plr, ...)
    if not HasAccess(plr) then
        return DoNotif(plr.Name .. " tidak punya izin untuk menjalankan command!", 5)
    end
    return oldCMDRun(plr, ...)
end
