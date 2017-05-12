require('DLib')

-- Credits to:
-- Deftsu

delay(function() 
    notification("Corki - The Bombardier loaded. \nBy Noddy", 5000) 
end, 1000)

local root = menu.addItem(SubMenu.new("Corki - The Bombardier"))
local Combo = root.addItem(SubMenu.new("Combo"))
	local useQ = Combo.addItem(MenuBool.new("Use Q",true))
	local useE = Combo.addItem(MenuBool.new("Use E",true))
	local useR = Combo.addItem(MenuBool.new("Use R",true))
	local useSheen = Combo.addItem(MenuBool.new("Sheen Weave",true))
	local ComboActive = Combo.addItem(MenuKeyBind.new("Combo", 32))
	
local Drawings = root.addItem(SubMenu.new("Drawings"))
	local DrawDMG = Drawings.addItem(MenuBool.new("Draw damage Q+R",true))
	
	
do
  _G.objectManager = {}
  objectManager.maxObjects = 0
  objectManager.objects = {}
  objectManager.camps = {}
  objectManager.barracks = {}
  objectManager.heroes = {}
  objectManager.minions = {}
  OnObjectLoop(function(object, myHero)
    objectManager.objects[GetNetworkID(object)] = object
  end)
  OnLoop(function(myHero)
    objectManager.maxObjects = 0
    for _, obj in pairs(objectManager.objects) do
      objectManager.maxObjects = objectManager.maxObjects + 1
      local type = GetObjectType(obj)
      if type == Obj_AI_Camp then
        objectManager.camps[_] = obj
      elseif type == Obj_AI_Hero then
        objectManager.heroes[_] = obj
      elseif type == Obj_AI_Minion then
        objectManager.minions[_] = obj
      end
    end
  end)
end	
	

OnLoop (function (myHero)

local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()

Killsteal()

if DrawDMG.getValue() then
	if CanUseSpell(myHero,_Q) == READY and ValidTarget(target, GetCastRange(myHero,_R)) then 
		qDMG = CalcDamage(myHero, target, 0, (30*GetCastLevel(myHero,_Q)+50+(0.5*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero))))
	else qDMG = 0
	end
	if CanUseSpell(myHero,_R) == READY and ValidTarget(target, GetCastRange(myHero,_R)) then
		rDMG = CalcDamage(myHero, target, 0, (50*GetCastLevel(myHero,_R)+20+((0.1*(GetCastLevel(myHero,_R))+0.1)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.3*GetBonusAP(myHero))))
	else rDMG = 0
	end
	
	DPS = qDMG + rDMG
	DrawDmgOverHpBar(target,GetCurrentHP(target),DPS,0,0xff00ff00)
end
-- Items
local Sheen = GetItemSlot(myHero,3057)
local TonsOfDamage = GetItemSlot(myHero,3078)

if ComboActive.getValue() then
-- Combo - noSheen

if ValidTarget(target,GetCastRange(myHero,_R)) then

if not useSheen.getValue() then

	local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
	if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and useQ.getValue() then
		CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
	end
	
	local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),5000, 150, GetCastRange(myHero,_E), 250, false, true)
	if EPred.HitChance == 1 and CanUseSpell(myHero,_E) == READY and useE.getValue() then
		CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
	end
if not GotBuff(myHero,"mbcheck2") then	
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 75, true, true)
	if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
		CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
	end
elseif GotBuff(myHero,"mbcheck2") then
	local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 150, true, true)
	if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
		CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
	end
end	
end
-- Combo SheenWeave

if Sheen >= 1 or TonsOfDamage >= 1 and useSheen.getValue() then

	if ValidTarget(target,GetRange(myHero)) and GotBuff(myHero,"sheen") == 1 then
		
	elseif ValidTarget(target,GetRange(myHero)) and GotBuff(myHero,"sheen") == 0 then
	
		local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
			if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and useQ.getValue() then
				CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
			end
	
		local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),5000, 150, GetCastRange(myHero,_E), 250, false, true)
			if EPred.HitChance == 1 and CanUseSpell(myHero,_E) == READY and useE.getValue() then
				CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
			end
		if not GotBuff(myHero,"mbcheck2") then	
			local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 75, true, true)
				if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
		elseif GotBuff(myHero,"mbcheck2") then
			local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 150, true, true)
				if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
		end
		
	elseif ValidTarget(target,GetCastRange(myHero,_R)) then
		
		local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
			if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and useQ.getValue() then
				CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
			end
	
		local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),5000, 150, GetCastRange(myHero,_E), 250, false, true)
			if EPred.HitChance == 1 and CanUseSpell(myHero,_E) == READY and useE.getValue() then
				CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
			end
		if not GotBuff(myHero,"mbcheck2") then	
			local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 75, true, true)
				if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
		elseif GotBuff(myHero,"mbcheck2") then
			local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 150, true, true)
				if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
		end

	end	

	
elseif ValidTarget(target,GetCastRange(myHero,_R)) then
		
		local QPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
			if QPred.HitChance == 1 and CanUseSpell(myHero,_Q) == READY and useQ.getValue() then
				CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
			end
	
		local EPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),5000, 150, GetCastRange(myHero,_E), 250, false, true)
			if EPred.HitChance == 1 and CanUseSpell(myHero,_E) == READY and useE.getValue() then
				CastSkillShot(_E, EPred.PredPos.x, EPred.PredPos.y, EPred.PredPos.z)
			end
		if not GotBuff(myHero,"mbcheck2") then	
			local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 75, true, true)
				if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
		elseif GotBuff(myHero,"mbcheck2") then
			local RPred = GetPredictionForPlayer(myHeroPos, target, GetMoveSpeed(target),1670, 250, GetCastRange(myHero,_R), 150, true, true)
				if RPred.HitChance == 1 and CanUseSpell(myHero,_R) == READY and useR.getValue() then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
		end
end


end
end	
end)

function Killsteal()
       for i,enemy in pairs(GetEnemyHeroes()) do
			
			if CanUseSpell(myHero,_Q) == READY then 
				local qDMG = CalcDamage(myHero, enemy, 0, (30*GetCastLevel(myHero,_Q)+50+(0.5*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero))))
				local QPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),1000, 250, GetCastRange(myHero,_Q), 250, false, true)
				if CanUseSpell (myHero,_Q) == READY and QPred.HitChance == 1 and ValidTarget(enemy,GetCastRange(myHero,_Q)) and GetCurrentHP(enemy) < qDMG then
					CastSkillShot(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
				end
			else
				qDMG = 0
			end
			
			if CanUseSpell(myHero,_R) == READY then
				local rDMG = CalcDamage(myHero, enemy, 0, (50*GetCastLevel(myHero,_R)+20+((0.1*(GetCastLevel(myHero,_R))+0.1)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.3*GetBonusAP(myHero))))
				local RPred = GetPredictionForPlayer(myHeroPos, enemy, GetMoveSpeed(enemy),1670, 250, GetCastRange(myHero,_R), 75, true, true)
				if CanUseSpell (myHero,_R) == READY and RPred.HitChance == 1 and ValidTarget(enemy,GetCastRange(myHero,_R)) and GetCurrentHP(enemy) < rDMG then
					CastSkillShot(_R, RPred.PredPos.x, RPred.PredPos.y, RPred.PredPos.z)
				end
			else
				rDMG = 0
			end
		-- local DPS = qDMG + rDMG
      end
end

function CalcDamage(source, target, addmg, apdmg)
    local ADDmg = addmg or 0
    local APDmg = apdmg or 0
    local ArmorPen = math.floor(GetArmorPenFlat(source))
    local ArmorPenPercent = math.floor(GetArmorPenPercent(source)*100)/100
    local Armor = GetArmor(target)*ArmorPenPercent-ArmorPen
    local ArmorPercent = Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    local MagicPen = math.floor(GetMagicPenFlat(source))
    local MagicPenPercent = math.floor(GetMagicPenPercent(source)*100)/100
    local MagicArmor = GetMagicResist(target)*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and math.floor(MagicArmor*100/(100+MagicArmor))/100 or math.ceil(MagicArmor*100/(100-MagicArmor))/100
    return (GotBuff(source,"exhausted")  > 0 and 0.4 or 1) * math.floor(ADDmg*(1-ArmorPercent))+math.floor(APDmg*(1-MagicArmorPercent))
end

function GetEnemyHeroes()
  local result = {}
  for _, obj in pairs(objectManager.heroes) do
    if GetTeam(obj) ~= GetTeam(GetMyHero()) then
      table.insert(result, obj)
    end
  end
  return result
end

function ValidTarget(unit, range)
    range = range or 25000
    if unit == nil or GetOrigin(unit) == nil or not IsTargetable(unit) or IsDead(unit) or not IsVisible(unit) or GetTeam(unit) == GetTeam(GetMyHero()) or not IsInDistance(unit, range) then return false end
    return true
end

function IsInDistance(p1,r)
    return GetDistanceSqr(GetOrigin(p1)) < r*r
end

function GetDistanceSqr(p1,p2)
    p2 = p2 or GetMyHeroPos()
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end

function GetMyHeroPos()
    return GetOrigin(GetMyHero()) 
end
