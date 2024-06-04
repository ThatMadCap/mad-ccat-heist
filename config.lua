Config = {

    Debug = false,

    Heist = {
        RequiredPolice = 2, -- Required Police Count (set to 0 for no check)
    },

    Skills = {
        GateHackXPGain = 3, -- amount of xp gained from gate hack
        GateHackXPLoss = 2, -- amount of xp lost from gate hack

        ThermiteHackXPGain = 3, -- amount of xp gained from thermite hack
        ThermiteHackXPLoss = 2, -- amount of xp lost from thermite hack

        CCATHackingXPGainSingle = 10, -- amount of xp gained from ccat hack
        CCATHackingXPLossSingle = 5, -- amount of xp lost from ccat hack

        CCATHackingXPGainMultiple = 30, -- amount of xp gained from ccat hack
        CCATHackingXPLossMultiple = 10, -- amount of xp lost from ccat hack

        RequiredForMultipleUSB = 800, -- amount of xp needed to make multiple USBs
    },

    Minigames = {
        Hack1 = { -- glow minigame path hack (outer gate)
            gridSize = 21, -- Max gridsize is 31 and should be an odd number
            lives = 3,
            timeLimit = 8000
        },
        Hack2 = { -- ps-ui thermite minigame (outside door)
            time = 10, -- in seconds
            gridSize = 6, -- gridsize
            incorrectBlocks = 3 -- amount of blocks you can fail
        },
        Hack3 = { -- glow minigame math hack (PD PC - Single USB)
            timeLimit = 15, -- in minutes
            operators = 1 -- operator count (1 => + | 2 => +,- | 3 => +,-,*)
        },
        Hack4 = { -- glow minigame math hack (PD PC - Multiple USB)
            timeLimit = 10, -- in minutes
            operators = 2, -- operator count (1 => + | 2 => +,- | 3 => +,-,*)
        },
    },

    Timers = { -- in seconds
        SingleUSB = 5, -- how long it takes to make a single USB (5 seconds)
        MultipleUSB = 5 * 60 * 1000, -- how long it takes to make multiple USBs (5 minutes)
        USBPullOutTime = 60, -- how long before the USB times out and you lose the 3rd eye on the PC (1 minute)
    }

}