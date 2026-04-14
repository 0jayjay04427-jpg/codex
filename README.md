# Morph GUI Reborn — with Featured Morph Tab

A Roblox morph GUI system with 170+ morphs and a **Featured Morph** tab that globally rotates a highlighted morph every 12 hours.

## Setup in Roblox Studio

### 1. Server Script (`ServerScript.lua`)
- Create a **Part** in Workspace (this is the trigger part players touch to open the GUI).
- Insert a **Script** inside that Part.
- Paste the contents of `ServerScript.lua` into that Script.

### 2. Featured Tab LocalScript (`FeaturedTab_LocalScript.lua`)
- Insert a **LocalScript** as a child of the Server Script (set `Disabled = true`).
- Paste the contents of `FeaturedTab_LocalScript.lua` into it.
- Alternatively, you can place it inside a **ScreenGui** in **StarterGui** if you want the Featured tab to always be visible without needing the trigger part.

## How the Featured Morph Works

- **Every 12 hours**, the server deterministically picks a morph from the full list.
- The selection uses `os.time()` so **all servers pick the same morph** at the same time — no DataStore or external service needed.
- A countdown timer shows players when the next rotation happens.
- Players can click "Morph Into Featured" to instantly morph into the featured character.
- When the featured morph rotates, all connected players are notified in real time with a smooth animation.

## Remotes Created

| Name | Type | Purpose |
|------|------|---------|
| `GetFeaturedMorph` | RemoteFunction | Client requests current featured morph + time remaining |
| `FeaturedMorphUpdated` | RemoteEvent | Server notifies clients when featured morph rotates |
