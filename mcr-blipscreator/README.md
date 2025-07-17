# MCR Blips Creator

A simple blip creator for ESX (FiveM) using ox_lib dialogs. Allows admins to create map blips in-game, which are persistent (saved in blips.json) and visible to all players after resource/server restart.

## Features
- Admin-only command to create blips
- Modern UI using ox_lib (inputDialog, showTextUI)
- Choose blip name, sprite (ID), color (with color picker), and size
- Set blip location interactively
- Blips are saved to `blips.json` and loaded for all players on join/restart

## Requirements
- [ESX Legacy](https://github.com/esx-framework/esx-legacy)
- [ox_lib](https://github.com/overextended/ox_lib)

## Installation
1. Download or clone this repository into your `resources` folder.
2. Ensure you have `ox_lib` and `es_extended` running on your server.
3. Add `ensure mcr-blipscreator` to your `server.cfg` **after** `ox_lib` and `es_extended`.
4. Make sure your `fxmanifest.lua` contains:
    ```lua
    shared_scripts {
        '@ox_lib/init.lua',
        'config/config.lua'
    }
    client_scripts {
        'client/client.lua'
    }
    server_scripts {
        'server.lua'
    }
    dependency 'es_extended'
    dependency 'ox_lib'
    files {
        'blips.json'
    }
    ```

## Usage
- Only users in groups defined in `config/config.lua` (`Config.AdminGroups`) can use the command.
- Default command: `/blipscreator` (can be changed in config)
- When used, a dialog will appear to enter blip details and select color.
- After confirming, press **E** at the desired location to place the blip.
- The blip will be saved and shown to all players.

## Customization
- Edit `config/config.lua` to change admin groups or command name.
- You can expand the color palette in `client/client.lua` by adding more blip color indices and their RGB values to the `blipColors` table.

## Removing Blips
- To remove a blip, manually delete it from `blips.json` and restart the resource.

## Credits
- Script by MCore Development
- Uses [ox_lib](https://github.com/overextended/ox_lib) for dialogs and UI

## License
MIT 