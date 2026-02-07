getgenv().SCRIPT_KEY = nil
local repo = 'https://raw.githubusercontent.com/hellotheren/hihitler/refs/heads/main/'
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
if UIS.KeyboardEnabled then
local Library = loadstring(game:HttpGet(repo .. 'library_main.lua'))()
else
local Library = loadstring(game:HttpGet(repo .. 'library_other.lua'))()
end
local ThemeManager = loadstring(game:HttpGet(repo .. 'library_theme.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'library_save.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles
local requestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)
Library.ShowCustomCursor = false -- Toggles the Linoria cursor globaly (Default value = true)
Library.NotifySide = "Left" -- Changes the side of the notifications globaly (Left, Right) (Default value = Left)

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "KeySystemService"
Junkie.identifier = "1000575" 
Junkie.provider = "KeySystemProvider"

-- UI Implementation
local keyToCheck = nil

-- Show custom UI 


local Window = Library:CreateWindow({

	Title = 'Key System',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true, 
	UnlockMouseWhileOpen = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 1
})

local Tabs = {

	Main = Window:AddTab('Key'),
}
local TabBoxes = {
    TabBox1 = Tabs.Main:AddLeftTabbox()
}
local TabBoxestabs = {
    Tab1 = TabBoxes.TabBox1:AddTab('credits'),
    Tab2 = TabBoxes.TabBox1:AddTab('key system')
}
local Discord = TabBoxestabs.Tab1:AddButton({
	Text = 'Discord',
	Func = function()
		setclipboard("https://discord.gg/mtbjM9f3BD")
		Library:Notify("Copied in clipboard!")
        s,e = pcall(function()
	requestFunc({
	Url = 'http://127.0.0.1:6463/rpc?v=1',
	Method = 'POST',
	Headers = {
		['Content-Type'] = 'application/json',
		Origin = 'https://discord.com'
	},
	Body = HttpService:JSONEncode({
		cmd = 'INVITE_BROWSER',
		nonce = HttpService:GenerateGUID(false),
		args = {code = "mtbjM9f3BD"}
		})
	})
end)
	end,
	DoubleClick = false,

	Tooltip = 'Discord',
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true -- Will make the button invisible (true / false)
})
local Unload = TabBoxestabs.Tab1:AddButton({
	Text = 'Unload',
	Func = function()
		Library.Unload()
	end,
	DoubleClick = false,

	Tooltip = 'will unload keysystem',
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true -- Will make the button invisible (true / false)
})

local GetKey = TabBoxestabs.Tab2:AddButton({
	Text = 'Get Key',
	Func = function()
        local link = Junkie.get_key_link()
		Library:Notify("Copying...")
		if link then
			setclipboard(link)  -- Copy to clipboard
			Library:Notify("Link copied to clipboard!")
		else
			Library:Notify("Wait 5 minutes!")
			return nil
		end
	
	end,
	DoubleClick = false,

	Tooltip = 'will copy key',
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true -- Will make the button invisible (true / false)
})
local InputBox = TabBoxestabs.Tab2:AddInput('InputBox', {
	Default = 'Input Box',
	Numeric = false, -- true / false, only allows numbers
	Finished = false, -- true / false, only calls callback when you press enter
	ClearTextOnFocus = true, -- true / false, if false the text will not clear when textbox focused
		
	Text = 'enter here key',
	Tooltip = 'pls faster daddy', -- Information shown when you hover over the textbox

	Placeholder = 'Skidded', -- placeholder text when the box is empty
	-- MaxLength is also an option which is the max length of the text

	Callback = function(Value)
		keyToCheck = Value
		print(keyToCheck)  print(getgenv().SCRIPT_KEY)
	end,
})
local CheckKey = TabBoxestabs.Tab2:AddButton({
	Text = 'Check Key',
	Func = function()
	Library:Notify("Checking key...")
	local result = Junkie.check_key(keyToCheck)
	if result and result.valid then
	    if result.message == "KEYLESS" then
			Library:Notify("Key is keyless!")
	        getgenv().SCRIPT_KEY = "KEYLESS"
	    elseif result.message == "KEY_VALID" then
			Library:Notify("Key is valid!")
	        getgenv().SCRIPT_KEY = keyToCheck
	    else
			Library:Notify("Key is invalid!")
	        return nil
	    end
	else
	    return nil
	end
	end,
	DoubleClick = false,

	Tooltip = 'will check key',
	DisabledTooltip = 'I am disabled!', -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true, -- Will make the button invisible (true / false)
})

while not getgenv().SCRIPT_KEY do
    task.wait(0.1)
end
Library.Unload()
