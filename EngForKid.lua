local widget = require("widget")
require("google-translate")
local composer = require("composer")
local composer = require("composer")
local scene = composer.newScene()
local vocab = {}
local cx, p, n, vocabTitle, vocabPos, clickSound, txtfText, imgSpeaker, imgCheck,showscore
local imgBackground,tmrSplash, bg,a,c,d,v,prevButton,nextButton
local image1
local cx = display.contentCenterX
local cy = display.contentCenterY

-------------------------------------------------
function BackToHome(event)
    if(event.phase == "ended") then
    composer.gotoScene("home")
end
end
-------------------------------------------------


local function vocabImage()
	return string.gsub(vocab[p], ".png", "")
end

local function imageTouch(event)
	if (event.phase == "ended") then
		reqSpeech(vocabImage(), "en")
	end
end

function changeImage(event)
	if (event.phase == "ended") then
		if (image) then
			image:removeSelf()
			image = nil
		end
		image = display.newImage(event.response.filename,system.DocumentsDirectory)
		image:translate(cx, 100)
		image:scale(0.5,0.5)
		image:addEventListener("touch", imageTouch)
	end
end

local function loadImageVocab()
	local params = {}
	local imageFile = vocab[p]
	local url = "http://www.phuketsmartcity.com/app/vocab/" .. imageFile
	network.download(url, "GET", changeImage, params, imageFile, system.DocumentsDirectory)
	--vocabPos.text = p .. " of " .. n
	--vocabTitle.text = vocabImage()
end

local function updatePos(x) 
	p = p + x
	if (p > n) then
		p = 1
	elseif (p < 1) then
		p = n
	end
end


local function loadTextVocab()
	local path = system.pathForFile("res/vocab.txt", system.ResourceDirectory)
	local file = io.open(path, "r") 
	if (file) then
		for line in file:lines() do
			vocab[#vocab + 1] = line;
		end
		io.close(file)
		file = nil		
		n = #vocab
	else
		print("Error loading file..")
		n = 0
	end
end

local function buttonPress(event)
	local button = event.target.id
	if (event.phase == "began") then
		audio.play(clickSound)
		if (button == "next") then
			updatePos(1)
		elseif (button == "prev") then
			updatePos(-1)
		else
			p = math.random(1, n)
		end
		loadImageVocab()
	end
end

local function imgSpeakerListener(event)
    if (event.phase == "began") then
        event.target.alpha = 0.3
    elseif (event.phase == "moved") then
        event.target.alpha = 1
    elseif (event.phase == "ended") then
        event.target.alpha = 1
        reqSpeech(vocabImage(), "en")
    end
end

local function imgCheckListener(event)
    if (tmrWarning) then
        timer.cancel(tmrWarning)
    end
    if (event.phase == "began") then
        event.target.alpha = 0.3
    elseif (event.phase == "moved") then
        event.target.alpha = 1
    elseif (event.phase == "ended") then
        event.target.alpha = 1
        if (txtfText.text == "") then
            reqSpeech("Please enter the answer ", "en")
            return
        end
        if (txtfText.text == vocabImage()) then
        	print("right")
        	txtfText.text = ""
            reqSpeech("good job","en")
            updatePos(1)
           -- score = score + 1
            loadImageVocab()
           -- score = score + 1

            --randomNumber()
        else
        	print("wrong")
            reqSpeech("wrong Please type again", "en")
            txtfText.text = ""
        end
    end
end

--------------------------------------------------------------------------------------

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
			composer.gotoScene("Translate")
		elseif (xStart < xEnd and swipeLength > 50) then 
			composer.gotoScene("home")
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


------------------------------------------------------------------------------------------
prevButton = widget.newButton(
	{
		defaultFile = "res/prev.png",
		overFile = "res/prev-over.png",
		id = "prev",
		onEvent = buttonPress
	}
)
nextButton = widget.newButton(
	{
		defaultFile = "res/next.png",
		overFile = "res/next-over.png",
		id = "next",
		onEvent = buttonPress
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

prevButton.x = cx - 100
nextButton.x = cx + 100
--randButton.y = 210
prevButton.y = 230
nextButton.y = 230

loadTextVocab()
clickSound = audio.loadSound("res/click.mp3")

p = 1




display.setDefault("background", 238/255, 232/255, 170/255)
txtfText = native.newTextField(cx,320,150,30)
txtfText.align = "center"

--bg = display.newImage("res/3.jpg", cx , cy)
showscore = display.newText("Learn English for kid", cx,3,"Arial",25)
showscore:setFillColor(0)
imgSpeaker = display.newImage("res/speaker.png", cx , 230)
imgCheck = display.newImage("res/check.png", cx , 400)
imgCheck:scale(0.7,0.7)
imgSpeaker:addEventListener("touch", imgSpeakerListener)
imgCheck:addEventListener("touch", imgCheckListener)
image1 = display.newImage("res/alligator.png")
image1:translate(cx,100)
image1:scale(0.5,0.5)

txtfText.isVisible = true
imgSpeaker.isVisible = true
imgCheck.isVisible = true
showscore.isVisible = true
prevButton.isVisible = true
nextButton.isVisible = true
image1.isVisible = true

	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		
		txtfText:removeSelf()
		imgSpeaker:removeSelf()
		imgCheck:removeSelf()
		showscore:removeSelf()
		prevButton:removeSelf()
		nextButton:removeSelf()
		image1:removeSelf()
		BackToHome:removeSelf()
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

