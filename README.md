# 🚗 Xdrive

## 📌 Project Overview

**Xdrive** is a smart remote car control application that allows users to manage key vehicle functions directly from their smartphone.

The project combines a **Flutter mobile application**, an **ESP32-based embedded system**, and **Firebase** to enable remote vehicle control and real-time status monitoring.

## 📱 Features

- 🔐 **Lock & Unlock** — Remotely control vehicle doors.
- 💡 **Light Control** — Manage interior and exterior lights.
- 📦 **Trunk Control** — Open and close the trunk remotely.
- 📊 **Real-Time Vehicle Status** — Monitor vehicle information.
- 🚗 **Remote Vehicle Control** — Interact with connected vehicle functions through the mobile application.

## 🏗️ System Architecture

```text
┌─────────────────────┐
│   Flutter Mobile    │
│       App           │
└──────────┬──────────┘
           │
           │ Internet
           ▼
┌─────────────────────┐
│      Firebase       │
│  Backend / Realtime │
└──────────┬──────────┘
           │
           │ Wi-Fi
           ▼
┌─────────────────────┐
│        ESP32        │
│    MicroPython      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Vehicle Functions │
│ Lights / Doors /    │
│ Trunk / Status      │
└─────────────────────┘
```

## 🛠️ Technologies

- **Flutter** — Cross-platform mobile application
- **ESP32** — Embedded control system
- **MicroPython** — ESP32 firmware
- **Firebase** — Backend and real-time data management

## 🎯 Objectives

- Develop a user-friendly connected-car interface.
- Enable remote control of vehicle functions.
- Integrate mobile, embedded, and cloud technologies.
- Provide real-time vehicle status monitoring.
- Explore IoT technologies for connected vehicles.

## 📂 Project Structure

```text
Xdrive/
├── mobile_app/       # Flutter application
├── esp32/            # ESP32 MicroPython code
├── firebase/           # Firebase connection
└── README.md
```
