
Tree = Class{}

local Tree_IMAGE = love.graphics.newImage('cactus.png')



-- speed at which the tree should scroll right to left
TREE_SPEED = GROUND_SCROLL_SPEED

-- height of tree image, globally accessible
TREE_HEIGHT = 70
TREE_WIDTH = 35

function Tree:init()

    self.x = VIRTUAL_WIDTH
    self.height = Tree_IMAGE:getHeight()
    -- set the Y to a random value halfway below the screen
    self.y = VIRTUAL_HEIGHT - self.height
    self.width = Tree_IMAGE:getWidth()
    self.remove = false
    self.past = false
end

function Tree:update(dt)
	--TREE_SPEED = TREE_SPEED + SCROLL_ACCELERATION * dt
	if self.x > -TREE_WIDTH then
        self.x = self.x - TREE_SPEED * dt
    else
        self.remove = true
    end

end

function Tree:render()
    love.graphics.draw(Tree_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end