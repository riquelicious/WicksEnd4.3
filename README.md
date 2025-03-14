# Wicks End - Firefighter Game

**Wicks End** is a 3D story-driven firefighter game where players rescue people and extinguish fires, using hand gestures for control. Built with **Godot 4.3**, the game offers a unique control mechanic using the **Mediapipe addon** to track hand gestures.

## Features
- **3D firefighting gameplay**: Save people and put out fires.
- **Hand gesture controls**: Use hand gestures for in-game actions (e.g., closed fist, open palm, victory, etc.).
- **Simple mechanics**: No dynamic story or immersive environments, focusing on quick action gameplay.
- **External installer**: Due to a bug with the Mediapipe addon, the first release uses an external installer to pack the editor along with the game.

## Tech Stack
- **Game Engine**: Godot 4.3
- **Hand Gesture Recognition**: Mediapipe addon for Godot (downloaded from [here](https://github.com/j20001970/GDMP))

## Installation & Setup

### Prerequisites
- **Godot Engine**: Version 4.3 or later.
- **Mediapipe addon**: Download and install the Mediapipe addon for Godot from [here](https://github.com/j20001970/GDMP).

### Steps to Run the Game
1. Clone or download the repository to your local machine.
2. Open the project in **Godot 4.3**.
3. Install the **Mediapipe addon** and set it up according to the instructions in the repository.
4. Run the game directly from the **Godot editor**.
5. If the export bug is still present, use the **external installer** to package the editor and game together.

### Known Issues
- **Export Bug**: The Mediapipe addon currently doesn't export with the game. The first release includes an external installer that bundles the editor to bypass this issue.

### Future Plans
- Fix the **export bug** with the Mediapipe addon.
- Improve hand gesture recognition and gameplay mechanics.
- Expand gameplay with more advanced features.

## License
No license has been chosen yet.

## Contributions
This is a personal project. Contributions are not expected at this time.

## Technologies
![Godot 4.3](https://img.shields.io/badge/Game%20Engine-Godot%204.3-blue)
![Mediapipe](https://img.shields.io/badge/Hand%20Gesture%20Recognition-Mediapipe-green)

## Status
![In Progress](https://img.shields.io/badge/Status-In%20Progress-yellow)
