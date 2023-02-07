local Lighting = game:GetService("Lighting")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local cam = game.Workspace.CurrentCamera
local Part
--local ProximityPromptService = game:GetService("ProximityPromptService")

local TimeEnabled = false
local OutdoorAmbientEnabled = false
local OutdoorAmbientVal = Color3.new()
local Dof = Instance.new("DepthOfFieldEffect")
Dof.Name = "Dof"
Dof.Enabled = false
Dof.FarIntensity = 0
Dof.FocusDistance = 0
Dof.InFocusRadius = 0
Dof.NearIntensity = 0
Dof.Parent = Lighting

local BrightnessEnabled = false
local ExposureEnabled = false

local CameraName:string
local EnabledButton
local HeadCamEnabled = false

local LightingBrightness
local ClockTime 
local ExposureCompensation

local CharactersTable = {}
local DefuaultLighSettings = {}

DefuaultLighSettings.Ambient = Lighting.Ambient
DefuaultLighSettings.ColorShift_Bottom = Lighting.ColorShift_Bottom
DefuaultLighSettings.ColorShift_Top = Lighting.ColorShift_Top
DefuaultLighSettings.ExposureCompensation = Lighting.ExposureCompensation
DefuaultLighSettings.OutdoorAmbient = Lighting.OutdoorAmbient

for i,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
    if v:IsA("Model") then
        table.insert(CharactersTable,
        {
            Name = v.Name,
            Mode = "Button", -- Button or Toggle
            Value = false, -- Default
            Callback = function(Selected)
                print(Selected,typeof(Selected))

                CameraName = v.Name
                print(CameraName)
            end
        }
    )
    end
end

function FindProperColorCorr()
    local find = false
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") then
            if v.TintColor ~= Color3.fromRGB(255,255,255) and  v.TintColor ~= Color3.fromRGB(108, 255, 66) and v.Contrast ~= 0 then
                return v
            end
        end
    end
    return 0
end

function FindNvgColorCorr()
    local find = false
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") then
            if v.TintColor == Color3.fromRGB(108, 255, 66) then
                return v
            end
        end
    end
    return 0
end


local ColorCorrection = FindProperColorCorr()
local NvgColorCorrection = FindNvgColorCorr()

local NewColorCor = Instance.new("ColorCorrectionEffect")
NewColorCor.Enabled = false

NewColorCor.Brightness = ColorCorrection.Brightness
NewColorCor.Contrast = ColorCorrection.Contrast
NewColorCor.Saturation = ColorCorrection.Saturation
NewColorCor.TintColor = ColorCorrection.TintColor

NewColorCor.Name = "CustomColorCorrection"

NewColorCor.Parent = Lighting



while not ColorCorrection do
    task.wait()
end

local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV33.lua"))()
Bracket:Notification({Title = "Text",Description = "NegriPidari",Duration = 10}) -- Duration can be nil for "x" to pop up
Bracket:Notification2({Title = "Text",Duration = 10})

-- see source code for more hidden things i forgot to add in this example
local Window = Bracket:Window({Name = "Window",Enabled = true,Color = Color3.new(1,0.5,0.25),Size = UDim2.new(0,496,0,496),Position = UDim2.new(0.5,-248,0.5,-248)}) do
    
    --Window.Name = "Name"
    --Window.Size = UDim2.new(0,496,0,496)
    --Window.Position = UDim2.new(0.5,-248,0.5,-248)
    --Window.Color = Color3.new(1,0.5,0.25)
    --Window.Enabled = true
    --Window.Blur = true

    --Window:SetValue("Flag",Value)
    --Window:GetValue("Flag")

    --Window:SaveConfig("FolderName","ConfigName")
    --Window:LoadConfig("FolderName","ConfigName")
    --Window:DeleteConfig("FolderName","ConfigName")
    --Window:GetDefaultConfig("FolderName")
    --Window:LoadDefaultConfig("FolderName")

    --Window.Background -- ImageLabel

    -- Watermark draggable
    local Watermark = Window:Watermark({
        Title = "BRM Graphic Tweaks",
        Flag = "UI/Watermark/Position",
        Enabled = true,
    })
    --Watermark.Enabled = true
    --Watermark.Title = "Text"
    --Watermark.Value = {0,0,0,0} -- Position, UDim2 but table

    local Tab = Window:Tab({Name = "Lighting Properties"}) do
        local Section = Tab:Section({Name = "Environment"}) do
            --Side might be "Left", "Right" or nil for auto side choose
            --Section:AddConfigSection("FolderName","Side")
            --Section.Name = "Name"

            local Divider = Section:Divider({Text = "Lighting settings",Side = "Left"})

            

            local GlobalShadows = Section:Toggle({Name = "GlobalShadows",Flag = "GlobalShadows",Side = "Left",Value = true,Callback = function(value)
            
                game:GetService("Lighting").GlobalShadows = value
            
            end})
        
            local BrightEnabled = Section:Toggle({Name = "Brightness Enabled",Flag = "BRM5/Lighting/BrightnessEnabled",Value = false,Callback = function(Value) BrightnessEnabled = Value end})

            LightingBrightness = Section:Slider({Name = "Brightness",Flag = "BRM5/Lighting/Brightness",Side = "Left",Min = 0,Max = 15,Value = Lighting.Brightness,Precise = 1,Unit = "",Callback = function(Value)
                Lighting.Brightness = Value
            end})

            ClockTime = Section:Slider({Name = "Time",Flag = "BRM5/Lighting/Time",Side = "Left",Min = 0,Max = 24,Value = Lighting.ClockTime ,Precise = 2,Unit = "",Callback = function(Value)
                Lighting.ClockTime = Value    
            end})

            local TimeEnablerBUTTON = Section:Toggle({Name = "Time",Flag = "BRM5/Lighting/TimeEnabled",Value = false,Callback = function(Value) Window.Flags["BRM5/Lighting/TimeEnabled"] = Value end})
            
            local hue,sat,val = Lighting.Ambient:ToHSV()

            local Ambient = Section:Colorpicker({Name = "Ambient",Flag = "AmbientVal",Side = "Left",Value = {hue,sat,val,0,false},Callback = function(HSVAR_Table,Color3)     
                Lighting.Ambient = Color3
            end})

            local hue,sat,val = Lighting.ColorShift_Bottom:ToHSV()

            local ColorShiftBottom = Section:Colorpicker({Name = "ColorShift_Bottom",Flag = "Colorpicker",Side = "Left",Value = {hue,sat,val,0,false},Callback = function(HSVAR_Table,Color3)  
                Lighting.ColorShift_Bottom = Color3
        
            end})

            local hue,sat,val = Lighting.ColorShift_Top:ToHSV()

            local ColorShiftTop = Section:Colorpicker({Name = "ColorShiftTop",Flag = "Colorpicker",Side = "Left",Value = {hue,sat,val,0,false},Callback = function(HSVAR_Table,Color3)  
                Lighting.ColorShift_Top = Color3
            end})

            local EnvironmentDiffuseScale = Section:Slider({Name = "EnvironmentDiffuseScale",Flag = "BRM5/Lighting/EnvironmentDiffuseScale",Side = "Left",Min = 0,Max = 1,Value = Lighting.EnvironmentDiffuseScale,Precise = 2,Unit = "",Callback = function(Value)
                Lighting.EnvironmentDiffuseScale = Value    
            end})

            local EnvironmentSpecularScale = Section:Slider({Name = "EnvironmentSpecularScale",Flag = "BRM5/Lighting/EnvironmentSpecularScale",Side = "Left",Min = 0,Max = 1,Value = Lighting.EnvironmentSpecularScale,Precise = 2,Unit = "",Callback = function(Value)
                Lighting.EnvironmentSpecularScale = Value    
            end})

            local hue,sat,val = Lighting.OutdoorAmbient:ToHSV()

            local OutdoorAmbient = Section:Colorpicker({Name = "OutdoorAmbient",Flag = "OutdoorAmbientVal",Side = "Left",Value = {hue,sat,val,0,false},Callback = function(HSVAR_Table,Color3)
                OutdoorAmbientVal = Color3  
                Lighting.OutdoorAmbient = Color3
            end})
        
            local OutdoorAmbientToggle = Section:Toggle({Name = "OutdoorAmbient",Flag = "OutdoorAmbientEnabled",Value = false,Callback = function(Value) OutdoorAmbientEnabled = Value end})

            local ShadowSoftness = Section:Slider({Name = "ShadowSoftness",Flag = "BRM5/Lighting/ShadowSoftness",Side = "Left",Min = 0,Max = 1,Value = Lighting.ShadowSoftness,Precise = 2,Unit = "",Callback = function(Value)
                Lighting.ShadowSoftness = Value    
            end})

            ExposureCompensation = Section:Slider({Name = "ExposureCompensation",Flag = "BRM5/Lighting/ExposureCompensation",Side = "Left",Min = -3,Max = 3,Value = Lighting.ExposureCompensation,Precise = 1,Unit = "",Callback = function(Value)
                Lighting.ExposureCompensation = Value    
            end})
            
            local ExposureCompensationEnablerBUTTON = Section:Toggle({Name = "Exposure",Flag = "BRM5/Lighting/ExposureEnabled",Value = false,Callback = function(Value) ExposureEnabled = Value end})

            local Button = Tab:Button({Name = "Button",Side = "Left",Callback = function()
                GlobalShadows.Value = true
                BrightEnabled.Value = false
                TimeEnablerBUTTON.Value = false
                local hue,sat,val = DefuaultLighSettings.Ambient:ToHSV()
                print("Something")
                Ambient.Value = {hue,sat,val,0,false}

                local hue,sat,val = DefuaultLighSettings.ColorShift_Bottom:ToHSV()
                print("Something")
                ColorShiftBottom.Value = {hue,sat,val,0,false}

                local hue,sat,val = DefuaultLighSettings.ColorShift_Top:ToHSV()
                print("Something")
                ColorShiftTop.Value = {hue,sat,val,0,false}
                
                local hue,sat,val = DefuaultLighSettings.OutdoorAmbient:ToHSV()
                print("Something")
                OutdoorAmbient.Value = {hue,sat,val,0,false}

                OutdoorAmbientToggle.Value = false

                ExposureCompensation.Value = DefuaultLighSettings.ExposureCompensation
             end})
           

     end
        if ColorCorrection ~= 0 then
            local Tab2 = Window:Tab({Name = "Color Correction Properties"}) do
                local Section2 = Tab2:Section({Name = "Environment"}) do
                    local Toggle = Section2:Toggle({Name = "Enabled",Flag = "ColorCorEnabled",Value = false,Callback = function(Value) 
                        ColorCorrection.Enabled = not Value 
                        NewColorCor.Enabled = Value end})
                    local Brightness = Section2:Slider({Name = "Brightness",Flag = "BRM5/Lighting/ColorCorBrightness",Side = "Left",Min =-1,Max = 1,Value = NewColorCor.Brightness,Precise = 2,Unit = "",Callback = function(Value)
                        print(Value)
                        NewColorCor.Brightness = Value
                    end})
                    local Contrast = Section2:Slider({Name = "Contrast",Flag = "BRM5/Lighting/ColorCorContrast",Side = "Left",Min =-1,Max = 1,Value = NewColorCor.Contrast,Precise = 2,Unit = "",Callback = function(Value)
                        NewColorCor.Contrast = Value
                    end})
                    
                    local Saturation = Section2:Slider({Name = "Saturation",Flag = "BRM5/Lighting/ColorCorSaturation",Side = "Left",Min =-1,Max = 1,Value = NewColorCor.Saturation,Precise = 3,Unit = "",Callback = function(Value)
                        NewColorCor.Saturation = Value
                    end})      
                    
                    local hue,sat,val = NewColorCor.TintColor:ToHSV()

                    local TintColor = Section2:Colorpicker({Name = "TintColor",Flag = "BRM5/Lighting/ColorCorTintColor",Side = "Left",Value = {hue,sat,val,0,false},Callback = function(HSVAR_Table,Color3)  
                        NewColorCor.TintColor = Color3
                    end})
    
                end
              
     
            end
        end   
if NvgColorCorrection ~= 0 then        
    local Tab3 = Window:Tab({Name = "NVG Options"}) do
        local Section3 = Tab3:Section({Name = "Environment"}) do
            local Brightness = Section3:Slider({Name = "Brightness",Flag = "BRM5/Lighting/NvgColorCorBrightness",Side = "Left",Min =-3,Max = 5,Value = NvgColorCorrection.Brightness,Precise = 2,Unit = "",Callback = function(Value)
                NvgColorCorrection.Brightness = Value
            end})
            local Contrast = Section3:Slider({Name = "Contrast",Flag = "BRM5/Lighting/NvgColorCorContrast",Side = "Left",Min =-3,Max = 10,Value = NvgColorCorrection.Contrast,Precise = 2,Unit = "",Callback = function(Value)
                NvgColorCorrection.Contrast = Value
            end})
            local Saturation = Section3:Slider({Name = "Saturation",Flag = "BRM5/Lighting/NvgColorCorSaturation",Side = "Left",Min =-3,Max = 5,Value = NvgColorCorrection.Saturation,Precise = 2,Unit = "",Callback = function(Value)
                NvgColorCorrection.Saturation = Value
            end})

            local hue,sat,val = NvgColorCorrection.TintColor:ToHSV()

            local TintColor = Section3:Colorpicker({Name = "TintColor",Flag = "BRM5/Lighting/NvgColorCorTintColor",Side = "Left",Value = {hue,sat,val,0,false},Callback = function(HSVAR_Table,Color3)  
                NvgColorCorrection.TintColor = Color3
            end})
         end
     end
end
    
local Tab4 = Window:Tab({Name = "DOF"}) do
    local Section4 = Tab4:Section({Name = "Environment"}) do
-- Dof.Enabled = false
-- Dof.FarIntensity = 0
-- Dof.FocusDistance = 0
-- Dof.InFocusRadius = 0
-- Dof.NearIntensity = 0

        local Enabled = Section4:Toggle({Name = "Enabled",Flag = "DofEnabled",Value = false,Callback = function(Value) Dof.Enabled  = Value end})
        local FarIntensity = Section4:Slider({Name = "FarIntensity",Flag = "BRM5/Lighting/DofFarIntensity",Side = "Left",Min =0,Max = 1,Value = Dof.FarIntensity,Precise = 4,Unit = "",Callback = function(Value)
            Dof.FarIntensity = Value
        end})
        local FocusDistance = Section4:Slider({Name = "FocusDistance",Flag = "BRM5/Lighting/DofFocusDistance",Side = "Left",Min =0,Max = 200,Value = Dof.FocusDistance,Precise = 4,Unit = "",Callback = function(Value)
            Dof.FocusDistance = Value
        end})
        local InFocusRadius = Section4:Slider({Name = "InFocusRadius",Flag = "BRM5/Lighting/DofInFocusRadius",Side = "Left",Min =0,Max = 50,Value = Dof.InFocusRadius,Precise = 4,Unit = "",Callback = function(Value)
            Dof.InFocusRadius = Value
        end})
        local NearIntensity = Section4:Slider({Name = "NearIntensity",Flag = "BRM5/Lighting/DofNearIntensity",Side = "Left",Min =0,Max = 1,Value = Dof.NearIntensity,Precise = 4,Unit = "",Callback = function(Value)
            Dof.NearIntensity = Value
        end})
     end
 end

 local Tab5 = Window:Tab({Name = "Helmet Camera"}) do
    local Section5 = Tab5:Section({Name = "Environment"}) do
         EnabledButton = Section5:Toggle({Name = "Enabled",Flag = "HeadCamEnabled",Value = false,Callback = function(Value) HeadCamEnabled  = Value end})
         local EnabledButtonKeybind = EnabledButton:Keybind({Flag = "Toggle/Keybind",Value = "M",DoNotClear = false,Mouse = false,Callback = function(Key_String,Pressed_Bool,Toggle_Bool) end,
         Blacklist = {"W","A","S","D","Slash","Tab","Backspace","Escape","Space","Delete","Unknown","Backquote"}})

         local Characters = Section5:Dropdown({Name = "Players",Flag = "CameraDropdown",Side = "Left",List = CharactersTable})
        print(Window.Flags["CameraDropdown"][1])
        
        
     end
 end

    local SettingsTab = Window:Tab({Name = "Settings"}) do
        local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
            local UIToggle = MenuSection:Toggle({Name = "Enabled",IgnoreFlag = true,Flag = "UI/Toggle",
            Value = Window.Enabled,Callback = function(Bool) Window.Enabled = Bool end})
            UIToggle:Keybind({Value = "RightShift",Flag = "UI/Keybind",DoNotClear = true})
            UIToggle:Colorpicker({Flag = "UI/Color",Value = {1,0.25,1,0,true},
            Callback = function(HSVAR,Color) Window.Color = Color end})
            MenuSection:Toggle({Name = "Open On Load",Flag = "UI/OOL",Value = true})
            MenuSection:Toggle({Name = "Blur Gameplay",Flag = "UI/Blur",Value = false,
            Callback = function(Bool) Window.Blur = Bool end})
            MenuSection:Toggle({Name = "Watermark",Flag = "UI/Watermark",Value = true,
            Callback = function(Bool) Window.Watermark.Enabled = Bool end})
        end
        SettingsTab:AddConfigSection("Bracket_Example","Left")
        local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
            BackgroundSection:Dropdown({Name = "Image",Flag = "Background/Image",List = {
                {Name = "Legacy",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://2151741365"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Hearts",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073763717"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Abstract",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073743871"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Hexagon",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073628839"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Circles",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071579801"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Lace With Flowers",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071575925"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Floral",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://5553946656"
                    Window.Flags["Background/CustomImage"] = ""
                end,Value = true},
                {Name = "Halloween",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://11113209821"
                    Window.Flags["Background/CustomImage"] = ""
                end},
                {Name = "Christmas",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://11711560928"
                    Window.Flags["Background/CustomImage"] = ""
                end}
            }})
            BackgroundSection:Textbox({Name = "Custom Image",Flag = "Background/CustomImage",Placeholder = "rbxassetid://ImageId",
            Callback = function(String) if string.gsub(String," ","") ~= "" then Window.Background.Image = String end end})
            BackgroundSection:Colorpicker({Name = "Color",Flag = "Background/Color",Value = {1,1,0,0,false},
            Callback = function(HSVAR,Color) Window.Background.ImageColor3 = Color Window.Background.ImageTransparency = HSVAR[4] end})
            BackgroundSection:Slider({Name = "Tile Offset",Flag = "Background/Offset",Min = 74,Max = 296,Value = 74,
            Callback = function(Number) Window.Background.TileSize = UDim2.new(0,Number,0,Number) end})
        end
    end
end
end
Window:SetValue("Background/Offset",74)
Window:LoadDefaultConfig("Bracket_Example")
Window:SetValue("UI/Toggle",Window.Flags["UI/OOL"])


--- END OF BRACKET

RS.RenderStepped:Connect(function()
    if CameraName == nil then
        return
    end
    Part = game:GetService("Workspace").Characters:FindFirstChild(CameraName).helmet.side

    if HeadCamEnabled and Part ~= nil then
        cam.CFrame = Part.CFrame
        Part.Transparency = 1
    end
end)

Lighting.Changed:Connect(function(Property)
    if Property == "OutdoorAmbient" and OutdoorAmbientEnabled and Lighting[Property] ~= OutdoorAmbientVal then
        Lighting.OutdoorAmbient = OutdoorAmbientVal
    end
    if Property == "Brightness" and Window.Flags["BRM5/Lighting/Brightness"] and BrightnessEnabled and Lighting[Property] ~= Window.Flags["BRM5/Lighting/Brightness"] then
        Lighting.Brightness = Window.Flags["BRM5/Lighting/Brightness"]
    elseif not BrightnessEnabled and LightingBrightness ~= nil then
        LightingBrightness.Value = Lighting.Brightness
    end

    if Property == "ClockTime" and Window.Flags["BRM5/Lighting/TimeEnabled"] and Lighting[Property] ~= Window.Flags["BRM5/Lighting/Time"] then
        Lighting.ClockTime = Window.Flags["BRM5/Lighting/Time"]
    elseif not Window.Flags["BRM5/Lighting/TimeEnabled"] and ClockTime~= nil then
        ClockTime.Value = Lighting.ClockTime 
    end

    if Property == "ExposureCompensation" and Window.Flags["BRM5/Lighting/ExposureCompensation"] and Lighting[Property] ~= Window.Flags["BRM5/Lighting/ExposureCompensation"] and ExposureEnabled then
        Lighting.ExposureCompensation = Window.Flags["BRM5/Lighting/ExposureCompensation"]
    elseif not ExposureEnabled and ExposureCompensation ~= nil then
        ExposureCompensation.Value = Lighting.ExposureCompensation
    end
end)

