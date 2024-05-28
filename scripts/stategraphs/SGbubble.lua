require("stategraphs/commonstates")

local events =
{
    CommonHandlers.OnLocomote(false, true),
}

local states =
{
    State
    {
        name = "idle",
        tags = {"idle", "canrotate", "canslide"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("float", true)
        end,
    },
	
    State
    {
        name = "appear",
        onenter = function(inst)
            inst.AnimState:PlayAnimation("appear")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },    

    State{
        name = "haunted",
        tags = {"busy"},
        
        onenter = function(inst)
			print("SHOULDPOP")
            inst.sg:GoToState("pop")            
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("haunted")
        end
    },

    State
    {
        name = "pop",
        onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("pop")            
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.components.explosive:OnBurnt()
					--inst:Remove()
                end
            end)
        },
    },
}

CommonStates.AddSimpleWalkStates(states, "float")
    
return StateGraph("bubble", states, events, "appear")