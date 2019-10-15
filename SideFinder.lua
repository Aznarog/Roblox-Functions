--//Aznarog
--//Given a point and part find the side of the part closest to the point
 
--//INSERT
local part
local point
 
local function findSide(point, part)
    --//Part Variables\\--
    local part = part
    local size = part.Size
    local partCFrame = part.CFrame
    local partPos = part.Position
 
    --//Vertices (from perspective of looking at part)
    local frontTopRight = Vector3.new(-size.X/2,size.Y/2,-size.Z/2)
    local frontTopLeft = Vector3.new(size.X/2,size.Y/2,-size.Z/2)
    local frontBottomRight = Vector3.new(-size.X/2,-size.Y/2,-size.Z/2)
    local frontBottomLeft = Vector3.new(size.X/2,-size.Y/2,-size.Z/2)
 
    local backTopRight = Vector3.new(-size.X/2,size.Y/2,size.Z/2)
    local backTopLeft = Vector3.new(size.X/2,size.Y/2,size.Z/2)
    local backBottomRight = Vector3.new(-size.X/2,-size.Y/2,size.Z/2)
    local backBottomLeft = Vector3.new(size.X/2,-size.Y/2,size.Z/2)
 
    --//Planes (6)
 
    --/Top Planes
 
    --Front Up Plane (||) uses fTR_to_bBL and fTL_to_bBR respectively
    local function aboveFrontUp(pos)
        local normalVector =  -(backBottomLeft-frontTopRight):Cross((backBottomRight-frontTopLeft)) -- the normal vector is pointing up
        local dot = normalVector:Dot(pos - frontTopRight)
        local isAbove = dot > 0
        return isAbove
    end
 
    -- This product is {−,0,+} if "dot" is below, on, above the plane, respectively.
 
 
    --Front Right Plane (/) uses fTR_to_bBL and fBL_to_bTR respectively
    local function aboveRightPlane(pos)
        local normalVector =  -(backBottomLeft-frontTopRight):Cross((backTopRight-frontBottomLeft))
        local dot = normalVector:Dot(pos - frontTopRight)
        local isAbove = dot > 0
        return isAbove
    end
 
    --Front Back Plane (||) uses fBR_to_bTL and fBL_to_bTR respectively
    local function aboveBackPlane(pos)
        local normalVector = -(backTopLeft-frontBottomRight):Cross((backTopRight-frontBottomLeft))
        local dot = normalVector:Dot(pos - frontBottomRight)
        local isAbove = dot > 0
        return isAbove
    end
    --Front Left Plane (\) uses fBR_to_bTL and fTL_to_bBR respectively
    local function aboveLeftPlane(pos)
        local normalVector = -(backTopLeft-frontBottomRight):Cross((backBottomRight-frontTopLeft))
        local dot = normalVector:Dot(pos - frontBottomRight)
        local isAbove = dot > 0
        return isAbove
    end
 
 
    --Vertical Planes Cutting through the part forms an X from birds eye view. Here we only need to consider X,Z
    --Consider fTL and BTR
    local function leftOfRightDiagonal(pos)
        local frontTopLeftXZ = Vector2.new(frontTopLeft.Z, frontTopLeft.X)
        local backTopRightXZ = Vector2.new(backTopRight.Z, backTopRight.X)
        local pointXZ = Vector2.new(pos.Z, pos.X)
        --take X to be the positive Y
        local gradient = (frontTopLeftXZ.Y - backTopRightXZ.Y)/(frontTopLeftXZ.X - backTopRightXZ.X)
        print(gradient.."rightDiagonal")
        if pointXZ.Y > gradient * pointXZ.X + 0 then -- equation of a line
            return true
        else
            return false
        end
    end
 
    --Consider fTR and BTL
    local function leftOfLeftDiagonal(pos)
        local frontTopRightXZ = Vector2.new(frontTopRight.Z, frontTopRight.X)
        local backTopLeftXZ = Vector2.new(backTopLeft.Z, backTopLeft.X)
        local pointXZ = Vector2.new(pos.Z, pos.X)
        --take X to be the positive Y
        local gradient = (frontTopRightXZ.Y - backTopLeftXZ.Y)/(frontTopRightXZ.X - backTopLeftXZ.X)
        print(gradient.."leftDiagonal")
        if pointXZ.Y > gradient * pointXZ.X + 0 then -- equation of a line
            return true
        else
            return false
        end
    end
 
    --//MAIN
    local point = point
    local p = part.CFrame:VectorToObjectSpace(point - partPos) -- this is a change of basis to the parts CFrame
 
    local aboveFrontUpVar = aboveFrontUp(p)
    local aboveRightPlaneVar = aboveRightPlane(p)
    local aboveBackPlaneVar = aboveBackPlane(p)
    local aboveLeftPlaneVar = aboveLeftPlane(p)
    local leftOfRightDiagonalVar = leftOfRightDiagonal(p)
    local leftOfLeftDiagonalVar = leftOfLeftDiagonal(p)
 
 
    --//Inequalities
    if aboveFrontUpVar and aboveRightPlaneVar and aboveBackPlaneVar and aboveLeftPlaneVar then
        print("TOP")
 
    elseif not aboveFrontUpVar and not aboveRightPlaneVar and not aboveBackPlaneVar and not aboveLeftPlaneVar then
        print("BOTTOM")
 
    elseif leftOfRightDiagonalVar and leftOfLeftDiagonalVar then
        print("RIGHT") -- its swapped on roblox for some reason
 
    elseif not leftOfRightDiagonalVar and not leftOfLeftDiagonalVar then
        print("LEFT")
 
    elseif leftOfRightDiagonalVar and not leftOfLeftDiagonalVar then
        print("BACK")
 
    elseif not leftOfRightDiagonalVar and leftOfLeftDiagonalVar then
        print("FRONT")
 
    else
        print("ERROR")
 
    end
 
end
   
findSide(point,part)
