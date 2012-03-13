--[[
TextArea v1.0.0

changelog:
----------

v1.0 - 12.03.2012
Initial release


This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2012 Andrew Barilla 
]]

TextArea = gideros.class(Sprite)

function TextArea:init(font, text, maxWidth)
	self.text = text
	self.font = font
	self.maxWidth = maxWidth
	self.textColor = 0x000000
	self.textFields = {}
	self.lineSpacing = 4
	self.letterSpacing = 0
end

function TextArea:redrawText()
	textFields = self.textFields
	
	for index, value in ipairs(textFields) do
		self.removeChild(value)
	end
	
	textFields = {}
		
	local isComplete = false
	local words = self:splitString(self.text)
	local textFieldCount = 0
	local textField = nil
	local nextY = 0
	local textColor = self.textColor
	local maxWidth = self.maxWidth
	local lineSpacing = self.lineSpacing
	local letterSpacing = self.letterSpacing
	local font = self.font
	
	while table.getn(words) > 0 do
		textField = TextField.new(font, "")
		textField:setTextColor(textColor)
		textField:setLetterSpacing(letterSpacing)
		textFieldCount = textFieldCount + 1
		textFields[textFieldCount] = textField			
			
		local isLineDone = false
		local lineText = ""
		local wordsInLine = 0
		
		while isLineDone == false and words[1] ~= nil do
			local tempLineText = nil
			if lineText == "" then
				tempLineText = words[1]
			else
				tempLineText = lineText .. " " .. words[1]
			end
			
			textField:setText(tempLineText)
			if textField:getWidth() >= maxWidth or maxWidth == 0 then
				if wordsInLine == 0 then
					lineText = tempLineText
					table.remove(words, 1)
				end
				textField:setText(lineText)
				isLineDone = true
			else
				wordsInLine = wordsInLine + 1
				lineText = tempLineText
				table.remove(words, 1)
			end
		end
		
		textField:setY(nextY)
		nextY = nextY + textField:getHeight() + lineSpacing
		self:addChild(textField)
	end
	
	self.textFields = textFields
end

function TextArea:splitString(s)
	local i1 = 1
	local ls = {}
	local append = table.insert
	local re = '%s+'

	while true do
		local i2,i3 = s:find(re,i1)
		if not i2 then
			local last = s:sub(i1)
			if last ~= '' then append(ls,last) end
			if #ls == 1 and ls[1] == '' then
				return {}
			else
				return ls
			end
		end
		append(ls,s:sub(i1,i2-1))
		i1 = i3+1
	end
end 

function TextArea:setText(text)
	self.text = text
	self:redrawText()
end

function TextArea:getText()
	return self.text
end

function TextArea:setTextColor(color)
	self.textColor = color
	
	if textFields == nil then return end
	
	for index, value in ipairs(textFields) do
		value:setTextColor(color)
	end
end

function TextArea:getTextColor()
	return self.textColor
end

function TextArea:setMaxWidth(width)
	self.maxWidth = width
	self:redrawText()
end

function TextArea:getMaxWidth()
	return self.maxWidth
end

function TextArea:setLineSpacing(spacing)
	self.lineSpacing = spacing
	self:redrawText()
end

function TextArea:getLineSpacing()
	return self.lineSpacing
end

function TextArea:setLetterSpacing(spacing)
	self.letterSpacing = spacing
	self:redrawText()
end

function TextArea:getLetterSpacing()
	return self.letterSpacing
end

