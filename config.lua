config = {
    flatbed_name = {
        "f550rb",
        "f550rbc",
        "16ramrb",
        "16ramrbc",
        "20ramrb",
        "20ramrbc"
    }, -- If you changed the name from f550rb to something else, change that here!
    carAttach = 305, -- Default: B // If you would like to change this, here are the controls list https://docs.fivem.net/docs/game-references/controls/
    controlText = "[~y~5~w~] raise bed ~r~-~w~ [~y~8~w~] lower bed" , -- This text displays next to the "control" panel near the back left of the bed.
    controlText2 = "[~y~5~w~] raise bed ~r~-~w~ [~y~4~w~] take Winch Cable ~r~-~w~[~g~Safe to Attach/Detach~w~]", -- This text displays next to the "control" panel near the back left of the bed.
    controlText3 = "[~y~5~w~] raise bed ~r~-~w~ [~y~4~w~] remove Winch Cable ~r~-~w~[~g~Safe to Attach/Detach~w~]", -- This text displays next to the "control" panel near the back left of the bed.
    carAttachLabel = "Press ~INPUT_REPLAY_STARTPOINT~ to attach entity.", -- ~INPUT_DETONATE~ is the G button. 
    carDetachLabel = "Press ~INPUT_REPLAY_STARTPOINT~ to detach entity.", -- ~INPUT_DETONATE~ is the G button. 
    SlidingSpeed = 20, -- Higher the Number, the slower the slider is. (note: if you want it slower, it will studder a bit.)
    FloatingText = true, -- Do you want 3d text near the controls, or a label?
    labelText = "[~y~5~w~] raise bed ~r~-~w~ [~y~8~w~] lower bed", -- This text displays on a label. (only if FloatingText is true)
    labelText2 = "[~y~5~w~] raise bed ~r~-~w~ [~y~4~w~] take Winch Cable ~n~~w~[~g~Safe to Attach/Detach~w~]", -- This text displays on a label. (only if FloatingText is true)
    labelText3 = "[~y~5~w~] raise bed ~r~-~w~ [~y~4~w~] remove Winch Cable ~n~~w~[~g~Safe to Attach/Detach~w~]", -- This text displays on a label. (only if FloatingText is true)
    ropeText = "[~y~6~w~] attach winch to closest Vehicle",
    noVeh = "Cannot find a vehicle to attach the cable too."
}