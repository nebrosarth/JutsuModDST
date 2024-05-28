
local assets = {
	Asset("ANIM", "anim/gnome_print.zip"),
}

local prefabs = {

}

local function SpawnPrint(inst)
	local footprint = SpawnPrefab("gnome_print")
	footprint.Transform:SetPosition(inst:GetPosition():Get())
	footprint.Transform:SetRotation(GetRotation(inst))
	--inst.SoundEmitter:KillSound("gnome_grenade/fall/fall")
	--inst.SoundEmitter:PlaySound("gnome_grenade/fall/explode")
end

local function footprint_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	inst:AddTag("NOCLICK")
	--inst:AddTag("lava")

    inst.Light:Enable(true)
    inst.Light:SetRadius(0.33)
    inst.Light:SetFalloff(0.66)
    inst.Light:SetIntensity(0.66)
    inst.Light:SetColour(255 / 255, 0 / 255, 255 / 255)
	
	inst.AnimState:SetBank("gnome_print")
	inst.AnimState:SetBuild("gnome_print")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst.Transform:SetRotation(0)

	inst:AddTag("scarytoprey")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({0,0,0,0}, 15, function(inst) inst:Remove() end)

	inst.persists = false

	return inst
end

return Prefab("common/gnome_print", footprint_fn, assets, prefabs)