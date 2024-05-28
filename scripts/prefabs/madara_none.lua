local assets =
{
	Asset( "ANIM", "anim/madara.zip" ),
	Asset( "ANIM", "anim/ghost_madara_build.zip" ),
}

local skins =
{
	normal_skin = "madara",
	ghost_skin = "ghost_madara_build",
}

local base_prefab = "madara"

local tags = {"MADARA", "CHARACTER"}

return CreatePrefabSkin("madara_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})