local widget = require("widget")
local JSON = require("json")
local composer = require("composer")
local composer = require("composer")
local scene = composer.newScene()
local cx, cy, txtTranslate, txfWord, button1, button2 ,button ,txtTranslate1, txfWord1 ,translate1
local translate,guideText,home
local bg1
local bg2
local runtime = 0
local scrollSpeed = 0.2

local cx = display.contentCenterX
local cy = display.contentCenterY


local function JSONFile2Table(filename)
    local path, file, contents
    path = system.pathForFile(filename, system.DocumentsDirectory)
    file = io.open(path, "r")
    if (file) then
        contents = file:read("*a")        
        io.close(file)
        return contents
    end
    return nil
end

local function loadJSONListener(event)
    if (event.isError) then
        print("Download failed...")
    elseif (event.phase == "ended") then
        print("Saved " .. event.response.filename)
        translate = JSON.decode(JSONFile2Table("translate.json"))
        txtTranslate.text = translate["text"][1]
    end
end

local function loadJSONListener1(event)
    if (event.isError) then
        print("Download failed...")
    elseif (event.phase == "ended") then
        print("Saved " .. event.response.filename)
        translate = JSON.decode(JSONFile2Table("translate.json"))
        txtTranslate1.text = translate["text"][1]
    end
end

local function doTranslate1(word)
    network.download(
        "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160927T025338Z.68dd354dfe623f89.15aa3c6fd8f24a9360a250e3d898bc5ccbfe2951&text=" .. word .. "&lang=en-th",
        "GET",
        loadJSONListener,
        {},
        "translate.json",
        system.DocumentsDirectory
    )
end

local function doTranslate2(word)
    network.download(
		"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160927T025338Z.68dd354dfe623f89.15aa3c6fd8f24a9360a250e3d898bc5ccbfe2951&text=".. word .."&lang=th-en",
        "GET",
        loadJSONListener1,
        {},
        "translate.json",
        system.DocumentsDirectory
    )
end


local function delScore(obj)
	if (obj) then 
		obj:removeSelf()
		obj = nil
	end
end	
local function delQ(obj)
	if (obj) then 
		obj:removeSelf()
		obj = nil
	end
end	

local function buttonPlay1(event)
	if(event.phase == "ended") then
		--score = 0
		txtTranslate.isVisible = true
		txfWord.isVisible = true
		button1.isVisible = true
		button2.isVisible = false
		btnPlay1.isVisible = false
		btnPlay2.isVisible = false
		--home.isVisible = true
		txfWord.text = ""
		txtTranslate.text = "Input Your Word"
		
 	end
end

local function buttonPlay2(event)
	if(event.phase == "ended") then
		--score = 0
		txtTranslate1.isVisible = true
		txfWord1.isVisible = true
		button1.isVisible = false
		button2.isVisible = true
		btnPlay2.isVisible = false
		btnPlay1.isVisible = false
		--home.isVisible = true
		txfWord1.text = ""
		txtTranslate1.text = "Input Your Word"
	end
end

local function buttonEvent1(event)
    if (event.phase == "ended") then
        doTranslate1(txfWord.text)
    end
end

local function buttonEvent2(event)
    if (event.phase == "ended") then
        doTranslate2(txfWord1.text)
    end
end

function BackToHome(event)
    if(event.phase == "ended") then
    composer.gotoScene("home")
end
end

-------------------------------------------------------------
local function screenTouched(event)
	local phase = event.phase
	local xStart = event.xStart
	local xEnd = event.x
	local swipeLength = math.abs(xEnd - xStart) 
	print("screen touch")
	if (phase == "began") then
		return true
	elseif (phase == "ended" or phase == "cancelled") then
		if (xStart > xEnd and swipeLength > 50) then 
			composer.gotoScene("home")
		elseif (xStart < xEnd and swipeLength > 50) then 
			composer.gotoScene("Translate")
		end 
	end	
end

function scene:create(event)
	local sceneGroup = self.view
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

-------------------------------------------------------------

txtTranslate = display.newText("Input your word", cx, 130,"Arial", 30)
txtTranslate:setFillColor(0)
txfWord = native.newTextField(cx, 200, 200, 40)
txfWord.align = "center"
txtTranslate1 = display.newText("Input your word", cx, 130,"Arial", 30)
txtTranslate1:setFillColor(0)
txfWord1= native.newTextField(cx, 200, 200, 40)
txfWord1.align = "center"

button1 = widget.newButton(
    {
        x = cx, y = 280,
        onEvent = buttonEvent1,
        defaultFile = "check.png",        
    }
)

button2 = widget.newButton(
    {
        x = cx, y = 280,
        onEvent = buttonEvent2,
        defaultFile = "check.png",        
    }
)



btnPlay1 = widget.newButton(
	{
		x = cx,
		y = 200,
		onEvent = buttonPlay1,
		label = "English to Thai",fontSize = 25, 
		
		--defaultFile = "EN-TH.jpeg"
	}
)


btnPlay2 = widget.newButton(
	{
		x = cx,
		y = 300,
		onEvent = buttonPlay2,
		label = "Thai to English",fontSize = 25
		
		--defaultFile = "TH-EN.jpg"
	}
)

BackToHome= widget.newButton(
	{
		x = cx+125 , y = 490,
		onEvent = BackToHome,
		defaultFile = "house.png"
	}
)

BackToHome:scale(0.6,0.6)


display.setDefault("background", 238/255, 232/255, 170/255)
guideText = display.newText("I love translate", cx , 25, "Tahoma", 40)
guideText:setFillColor( 0, 0, 0 )

		txtTranslate.isVisible = false
		txfWord.isVisible = false
		txtTranslate1.isVisible = false
		txfWord1.isVisible = false
		button1.isVisible = false
		button2.isVisible = false
		btnPlay1.isVisible = true
		btnPlay2.isVisible = true
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		
		txtTranslate1:removeSelf()
		txtTranslate:removeSelf()
		txfWord1:removeSelf()
		txfWord:removeSelf()
		button2:removeSelf()
		button1:removeSelf()
		btnPlay2:removeSelf()
		btnPlay1:removeSelf()
		BackToHome:removeSelf()
		guideText:removeSelf()

	elseif (phase == "did") then
		--txtMyfoodee.isVisible = false
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

