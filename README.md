# Moodscape


![Image](https://github.com/user-attachments/assets/3fd5d11d-b705-4fbb-a827-2a19ef3cccdd)



**Moodscape** is an Android application built with Flutter that uses AI technology to analyze **handwritten or printed text** and **facial expressions** from images. It classifies both into psychological traits and provides personalized suggestions and motivation based on the results.

## Tech Stack

- **Flutter** – Main framework for building the app
- **TensorFlow Lite** – For running machine learning models locally on Android devices
- **Teachable Machine by Google** – Used to train and export image classification models
- **Camera / Gallery Input** – For capturing or selecting images from the device

## Core Features

### Text Classification
- The app detects **text from images** using Optical Character Recognition (OCR).
- Then it classifies the detected text into one of 4 DISC personality types:
  - **Dominance**
  - **Compliance**
  - **Steadiness**
  - **Influence**

### Facial Expression Classification
- Detects faces in an image and classifies the expression into one of the 7 emotional categories:
  - Anger
  - Sadness
  - Surprise
  - Happy
  - Disgust
  - Fear
  - Neutral

### Output & Motivation
- Based on both classification results (text and facial expression):
  - Provides **descriptions of two personality traits**.
  - Offers **personalized suggestions and motivational insights**.

## How to Use

1. **Take or select a photo** that includes facial expression and/or text.
2. Moodscape analyzes the image using on-device AI.
3. Receive **trait analysis** and **personalized motivation** instantly.

## Machine Learning Models

- Models are trained using Teachable Machine.

- Exported as TensorFlow Lite models and integrated into the Flutter app for local inference.

## Permissions Required
- The app requires access to:

- Camera

Storage (to pick images from gallery)

📄 License
MIT License


## 📦 Installation (Development)

```bash
git clone https://github.com/yourusername/moodscape.git
cd moodscape
flutter pub get
flutter run


