Config = {}

-- Command to reward the player
Config.Command = 'discordreward' -- Change command if needed

-- Discord API Settings
Config.BotToken = 'bot_token'  -- Replace with your bot token
Config.GuildID = 'Guild_ID'            -- Replace with your Discord server's guild ID
Config.RoleID = 'Role_ID'             -- Replace with the Discord Role ID you want to check to reward


Config.Rewards = {
    Cash = 1000,
    Bank = 5000,
    EnableItems = true,   -- Enable or disable item rewards
    Items = {             
        { name = 'diamond', amount = 2 },
        { name = 'goldbar', amount = 1 }
    }
}

Config.CooldownDays = 30  -- Number of days before the player can redeem again

Config.Debug = true  -- Set to true for testing

Config.Messages = {
    NoRole = 'You are not boosting the discord server.',
    RewardSuccess = 'You have been rewarded successfully. Thank you for your support!',
    Cooldown = 'You have already claimed your reward this month.',
    Error = 'An error occurred while processing your reward.',
}