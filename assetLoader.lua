AssetLoader = {
    toLoad = {
        --images
        {type = "image", name = "player", path = "assets/graphics/player/player.png"},
        {type = "image", name = "player_mask", path = "assets/graphics/player/player_mask.png"},
        
        --quads
        {
            type = "quad",
            unique = false,
            name = "player_animations_",
            imageName = "player",
            x = 0, y = 0,
            w = 28, h = 28,
            cols = 3, rows = 1,
            spacing = 0
        },

        --sounds
        {type = "sound", name = "die", path = "assets/sound/sfx_die.wav", soundType = "static"},
    }
}