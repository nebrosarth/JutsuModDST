
local assets=
{
	Asset("ANIM", "anim/gnome_grenade.zip"),
	Asset("ANIM", "anim/swap_gnome_grenade.zip"),
	Asset("ATLAS", "images/inventoryimages/gnome_grenade.xml"),
	Asset("IMAGE", "images/inventoryimages/gnome_grenade.tex"),
}

local prefabs = 
{
	"collapse_small",
	"gnomenade_fx",
	"groundpound_fx",
    "groundpoundring_fx",
	"explosivehit",
	"gnome_print",
}	
 
 
local function DoExplode(self)
    local explosiverange = gexpsize
	
    local stacksize = self.inst.components.stackable ~= nil and self.inst.components.stackable:StackSize() or 1
    local totaldamage = self.explosivedamage * stacksize
	
    local x, y, z = self.inst.Transform:GetWorldPosition()
    -- Players are off limits now
    local ents = TheSim:FindEntities(x, y, z, explosiverange, nil, { "INLIMBO", "player" })
 
    for i, v in ipairs(ents) do
        if v ~= self.inst and v:IsValid() and not v:IsInLimbo() then
            if v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                v.components.workable:WorkedBy(self.inst, self.buildingdamage)
            end
 
            --Recheck valid after work
            if v:IsValid() and not v:IsInLimbo() then
                if self.lightonexplode and
                    v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    --v.components.burnable:Ignite()
                end
 
                if v.components.combat ~= nil then
                    v.components.combat:GetAttacked(self.inst, totaldamage, nil)
                end
 
                v:PushEvent("explosion", { explosive = self.inst })
            end
        end
    end
	
end
 
local function OnExplodeFn(inst)
	SpawnPrefab("gnomenade_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("groundpound_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("gnomeringfx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("gnome_print").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("gnomenade/fall/fall")
	SpawnPrefab("sparks").Transform:SetPosition(inst.Transform:GetWorldPosition())
    DoExplode(inst.components.explosive)
end
 
local function OnHitWater(inst, attacker, target)
    inst.components.explosive:OnBurnt()
end
 
local function common_fn(bank, build, anim, tag, isinventoryitem)
    local inst = CreateEntity()
 
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
 
    if isinventoryitem then
        MakeInventoryPhysics(inst)
    else
        inst.entity:AddPhysics()
        inst.Physics:SetMass(1)
        inst.Physics:SetCapsule(0.2, 0.2)
        inst.Physics:SetFriction(0)
        inst.Physics:SetDamping(0)
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
    end
 
    if tag ~= nil then
        inst:AddTag(tag)
    end
 
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim, true)
 
    inst.entity:SetPristine()
 
    if not TheWorld.ismastersim then
        return inst
    end
 
    inst:AddComponent("locomotor")
 
    inst:AddComponent("complexprojectile")
 
    return inst
end
 
 
local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_gnome_grenade", "swap_gnome_grenade")
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end
 
local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
 
    inst.AnimState:PlayAnimation("spin_loop", true)
	inst.SoundEmitter:PlaySound("gnomenade/fall/fall")
		
    inst.Physics:SetMass(0.5)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

 
local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local x, y, z
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        x, y, z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(x, y, z) then
            return Vector3(x, y, z)
        end
    end
    return Vector3(x, y, z)
end
 
local function fn()
    local inst = common_fn("gnome_grenade", "gnome_grenade", "idle", "projectile", true)
	inst.entity:AddSoundEmitter()
    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true
 
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = TUNING.GUNPOWDER_DAMAGE*ggnomedmg
	inst.components.explosive.buildingdamage = 30
    -- So explosion doesn't affect players
	
	inst.components.explosive.explosiverange = ggnomexp
	inst.components.explosive.lightonexplode = false
	
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitWater)
 
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(10, 12)
 
    inst:AddComponent("inspectable")
 
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "gnome_grenade"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gnome_grenade.xml"
 
    inst:AddComponent("stackable")
 
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true
 
    return inst
end
 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GNOME_GRENADE = "По-настоящему разрушительна."

 
return Prefab( "common/inventory/gnome_grenade", fn, assets) 