

Dino = Class{}

local Gravity = 8

function Dino:init()

	self.image = love.graphics.newImage('Dino1.png')
	self.width = self.image:getWidth() --80
    self.height = self.image:getHeight() --85

    self.x = VIRTUAL_WIDTH / 8 - (self.width / 2)
    self.yground = VIRTUAL_HEIGHT * 8/10   - (self.height / 2)
    self.y = self.yground
    self.jumpstate = false

    self.dy = 0
end

--AABB collision detector
function Dino:collides(tree)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= tree.x and self.x + 2 <= tree.x + TREE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= tree.y and self.y + 2 <= tree.y + TREE_HEIGHT then
            return true
        end
    end

    return false
end

function Dino:update(dt)
	if (self.jumpstate) then
		-- apply gravity to velocity
    	self.dy = self.dy + Gravity * dt

    	-- apply current velocity to Y position
    	self.y = self.y + self.dy
    	if (self.y > self.yground) then
     			self.y = self.yground
    			self.jumpstate = false
    	end

	end
	
	if ((love.keyboard.wasPressed('space')) and (self.jumpstate == false)) then
        self.jumpstate = true
        self.dy = -7
        sounds['jump']:play()
    end

end

function Dino:render()
	love.graphics.draw(self.image, self.x, self.y)
end