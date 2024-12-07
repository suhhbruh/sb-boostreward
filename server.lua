local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config

local redemptionData = {}

-- Load redemption data when the resource starts
CreateThread(function()
    local data = LoadResourceFile(GetCurrentResourceName(), 'redemptions.json')
    if data then
        redemptionData = json.decode(data)
    end
end)

-- Save redemption data
local function SaveRedemptionData()
    SaveResourceFile(GetCurrentResourceName(), 'redemptions.json', json.encode(redemptionData), -1)
end

-- Function to get Discord user ID from player identifiers
local function GetDiscordID(source)
    for _, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, 8) == 'discord:' then
            return string.sub(v, 9) 
        end
    end
    return nil
end

-- Function to check if a Discord user has the required role
local function HasDiscordRole(discordID, callback)
    local guildID = Config.GuildID
    local roleID = Config.RoleID
    local botToken = Config.BotToken

    local url = ('https://discord.com/api/guilds/%s/members/%s'):format(guildID, discordID)
    local headers = {
        ['Authorization'] = 'Bot ' .. botToken,
        ['Content-Type'] = 'application/json'
    }

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            local memberData = json.decode(response)
            for _, role in ipairs(memberData.roles) do
                if role == roleID then
                    callback(true)
                    return
                end
            end
            callback(false)
        else
            callback(false)
        end
    end, 'GET', '', headers)
end

-- Function to reward the player
local function RewardPlayer(player)
    if Config.Rewards.Cash and Config.Rewards.Cash > 0 then
        player.Functions.AddMoney('cash', Config.Rewards.Cash)
    end
    if Config.Rewards.Bank and Config.Rewards.Bank > 0 then
        player.Functions.AddMoney('bank', Config.Rewards.Bank)
    end
    if Config.Rewards.EnableItems and Config.Rewards.Items and #Config.Rewards.Items > 0 then
        for _, item in ipairs(Config.Rewards.Items) do
            player.Functions.AddItem(item.name, item.amount)
            TriggerClientEvent('inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items[item.name], 'add')
        end
    end
end

-- Check if the player can redeem the reward
local function CanRedeem(discordID)
    if Config.Debug then return true end

    local lastRedeemed = redemptionData[discordID]
    if not lastRedeemed then return true end

    local currentTime = os.time()
    local cooldownTime = Config.CooldownDays * 86400

    return (currentTime - lastRedeemed) >= cooldownTime
end

-- Event to check the role and reward the player
RegisterServerEvent('sb-boostreward:checkRole')
AddEventHandler('sb-boostreward:checkRole', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local discordID = GetDiscordID(src)

    if not discordID then
        TriggerClientEvent('sb-boostreward:client:error', src)
        return
    end
    if not CanRedeem(discordID) then
        TriggerClientEvent('sb-boostreward:client:cooldown', src)
        return
    end
    HasDiscordRole(discordID, function(hasRole)
        if hasRole then
            RewardPlayer(Player)
            redemptionData[discordID] = os.time()
            SaveRedemptionData()
            TriggerClientEvent('sb-boostreward:client:rewardSuccess', src)
            print(('Player %s successfully redeemed their reward.'):format(GetPlayerName(src)))
        else
            TriggerClientEvent('sb-boostreward:client:noRole', src)
        end
    end)
end)
