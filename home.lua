local widget = require("widget")
local composer = require("composer")
local composer = require("composer")
local scene = composer.newScene()
local path, db, tableView ,cx, cy
local id, name, amt, food, Type
local TextField, insert, search,titie, txtMyfoodee, txtVegetableee
local myRectangle2, myRectangle, Galby, txtMainFood, txtMainActivity




local cx = display.contentCenterX
local cy = display.contentCenterY

function goTOEng(event)
    if(event.phase == "ended") then
    composer.gotoScene("EngForKid")
end
end

function gotoTrans(event)
    if(event.phase == "ended") then
    composer.gotoScene("Translate")
end
end

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
			composer.gotoScene("EngforKid")
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
display.setDefault("background",1,0.941,0.96)




myRectangle = display.newRect( 160, -10, 325, 80 )
--myRectangle.strokeWidth = 10
myRectangle:setFillColor( 24/255, 116/255, 205/255)
myRectangle:setStrokeColor( 0, 0, 0 )

Myfood = widget.newButton(
	{
		x = cx , y = 170,
		onEvent = goTOEng,
		defaultFile = "language.png"
	}
)

MyActivity= widget.newButton(
	{
		x = cx , y = 300,
		onEvent = gotoTrans,
		defaultFile = "translate.png"
	}
)



Galby = display.newText("English for kid" ,160 ,0 , "Arial" ,25)
Galby:setFillColor(0)


txtMainActivity = display.newText("Translate" ,cx ,355 , "Arial" ,17)
txtMainActivity:setFillColor(0)

txtMainFood = display.newText("Learn English for kid" ,cx ,220 , "Arial" ,17)
txtMainFood:setFillColor(0)





end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		
		
		myRectangle.isVisible = false
		

		Galby:removeSelf()
		
		Galby.isVisible = false
		
		Myfood:removeSelf()
		MyActivity:removeSelf()
		txtMainActivity.isVisible = false
		txtMainFood.isVisible = false
		
		
		
		--Runtime:removeEventListener("touch", screenTouched)
		--db:close()
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

