# Task Buddy

A simple, beautiful task completion app designed for accessibility and ease of use.

## Features

✨ **Create Custom Tasks** with multiple steps  
📸 **Add Photos** to each step using the camera  
🔊 **Text-to-Speech** - tap any instruction to hear it read aloud  
🎨 **Pastel Color Coding** - assign colors to different tasks  
🎉 **Celebration Screen** - encouraging feedback when tasks are completed  
💾 **Local Storage** - no login or internet required  
📱 **iPad Optimized** - large, readable text and touch targets  

## How to Use

### Edit Mode
1. Toggle "Edit Mode" in the top right
2. Tap **+** to create a new task
3. Enter a task title and choose a color
4. Add steps:
   - Tap "Add Step"
   - Write the instruction
   - Optionally take a photo with the camera
5. Tap "Save" when done

### Do Tasks Mode
1. Toggle off "Edit Mode"
2. Tap a task card to start
3. For each step:
   - View the photo (if added)
   - Tap the text box to hear it read aloud
   - Tap "Done" when complete
4. Complete all steps to see the celebration! 🎉

## Setup

### Requirements
- Flutter SDK
- iOS device or simulator
- Xcode (for iOS development)

### Installation

```bash
flutter pub get
flutter run
```

## Tech Stack

- **Flutter** - Cross-platform framework
- **image_picker** - Camera integration
- **flutter_tts** - Text-to-speech
- **shared_preferences** - Local storage
- **confetti** - Celebration animations

## Design Philosophy

Simple, accessible, and encouraging. Built for users who benefit from visual + audio guidance and clear, colorful interfaces.

---

Made with ❤️ for learning and independence.
