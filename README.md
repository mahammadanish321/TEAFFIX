<div align="center">

# 🚦 TRAFFIX AI
### Centralized City-Wide Smart Traffic Management & Multi-Camera ANPR Digital Twin
**Smart India Hackathon (SIH 2026) Working Prototype**

[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20macOS-blue?style=for-the-badge&logo=linux)](https://github.com/mahammadanish321/TEAFFIX)
[![Frontend](https://img.shields.io/badge/Frontend-Electron%20%7C%20React%20Native%20%7C%20MapLibre%203D-61DAFB?style=for-the-badge&logo=react)](https://github.com/mahammadanish321/TEAFFIX)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%7C%20Express%20%7C%20WebSocket-339933?style=for-the-badge&logo=nodedotjs)](https://github.com/mahammadanish321/TEAFFIX)
[![AI Vision](https://img.shields.io/badge/AI%20Vision-YOLOv8%20%7C%20ByteTrack%20%7C%20EasyOCR-FF6F00?style=for-the-badge&logo=pytorch)](https://github.com/mahammadanish321/TEAFFIX)
[![Routing](https://img.shields.io/badge/Routing-OSRM%20%7C%20OpenStreetMap-7AC143?style=for-the-badge&logo=openstreetmap)](https://github.com/mahammadanish321/TEAFFIX)

</div>

---

## 📌 Executive Summary & Problem Statement

Modern smart cities struggle with fragmented traffic surveillance, optical character recognition latency on fast-moving vehicles, and lack of unified multi-camera vehicle tracking.

**TRAFFIX AI** solves this with an end-to-end distributed architecture:
1. **Edge Computer Vision Daemon**: High-speed YOLOv8 vehicle detection, ByteTrack persistent multi-object tracking, and Deep Learning ANPR with multi-frame OCR voting.
2. **Central WebSocket & Re-ID Gateway**: Instant sub-50ms event broadcasting and multi-camera transit path correlation.
3. **3D Interactive Digital Twin Desktop Application**: Built with Electron, React Native, and MapLibre 3D WebGL, rendering real-world OpenStreetMap road network trajectories using OSRM Contraction Hierarchies.

---

## 🎬 Live Prototype Demo

<div align="center">

<a href="https://res.cloudinary.com/dmi7vzu8w/video/upload/v1790389429/our_backend_so_poyq8j.mp4" target="_blank">
  <img src="./docs/demo.gif" alt="TRAFFIX AI Live Prototype Demo" width="100%" style="border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.3);" />
</a>

<p><em>👆 <b>Live Prototype in Action</b> — Click the video above to stream the full 1080p demo with audio.</em></p>

[![Watch Full Demo Video](https://img.shields.io/badge/▶%20Watch%20Full%201080p%20Demo%20Stream-Cloudinary%20CDN-E11D48?style=for-the-badge&logo=youtube)](https://res.cloudinary.com/dmi7vzu8w/video/upload/v1790389429/our_backend_so_poyq8j.mp4)

</div>

---

## 🏗️ System Architecture

```mermaid
flowchart LR
    subgraph Edge["🧠 Edge AI & Surveillance (Traffix_Ai :8002)"]
        direction TB
        CCTV["📹 Multi-Junction CCTV Streams<br/><i>(Park St, Esplanade, Salt Lake, Howrah, Gariahat)</i>"]
        
        subgraph Pipeline["⚡ Deep Learning ANPR Pipeline"]
            direction TB
            YOLO["1. YOLOv8 Vehicle Detector"]
            BT["2. ByteTrack Persistent Tracker"]
            LPD["3. YOLO Plate Localizer"]
            OCR["4. EasyOCR + CLAHE Filter"]
            VOTE["5. Multi-Frame Consensus Voting"]
            YOLO --> BT --> LPD --> OCR --> VOTE
        end

        STREAM["📡 Low-Latency MJPEG Streamer"]
        
        CCTV --> Pipeline
        CCTV -.-> STREAM
    end

    subgraph Backend["⚙️ Central Hub (trafix.backend :8000)"]
        direction TB
        REST["REST API Server (Express.js)"]
        STORE[("In-Memory & State Store")]
        REID["Multi-Camera Re-ID Matcher"]
        WS["WebSocket Real-Time Gateway"]

        REST <--> STORE
        REST --> REID
        REID --> WS
    end

    subgraph Frontend["💻 3D Digital Twin (TraffixAI-F :8081)"]
        direction TB
        MAP["MapLibre 3D WebGL Digital Twin"]
        OSRM["OSRM Road Geometry Engine"]
        ANALYTICS["Real-Time Congestion Analytics"]
        POPUP["Live Camera POPUP & MJPEG Feeds"]

        OSRM --> MAP
        ANALYTICS -.-> MAP
    end

    %% Data Flow Connections
    VOTE ==>|HTTP POST Detection Events| REST
    STREAM ==>|Direct MJPEG Video Stream| POPUP
    WS ==>|Real-Time WebSocket Push| MAP
    WS ==>|Telemetry & Alert Events| ANALYTICS
```

---

## ✨ Key Features & Capabilities

* 🎯 **Sub-Pixel License Plate Recognition (ANPR)**: Dedicated YOLO license plate localization + bilateral filtering + CLAHE preprocessing + EasyOCR with multi-frame consensus voting.
* 🚗 **Sticky Zero-Drop Multi-Object Tracking**: ByteTrack with 120-frame temporal buffer ensures vehicles never lose ID during headlight flare, motion blur, or distance variations.
* 🗺️ **True Road-Network 3D Routing**: Powered by OpenStreetMap and OSRM Contraction Hierarchies with Catmull-Rom spline interpolation—zero straight-line diagonal artifacts across buildings.
* 📍 **Google Maps-Style Dynamic Zoom Scaling**: Camera markers feature 3D ground-pinning needles (`pitchAlignment: 'map'`) that dynamically scale from compact dots at city-level zoom to full interactive cards at street-level zoom.
* 🔁 **Multi-Camera Re-ID & Journey Reconstruction**: Automatically correlates visual and plate signatures across different CCTV junctions to trace journey paths in real time.
* ⚡ **Ultra-Low Latency Streaming**: Multithreaded MJPEG encoding achieving smooth 30+ FPS video streaming on standard CPU hardware.

---

## ⚡ 1-Click Quickstart (For Judges & Evaluators)

### Prerequisites
* **Node.js** (v18 or higher)
* **Python** (v3.10 or higher)
* **Git**

### 🐧 Option 1: Linux / macOS (1-Click Command)
Clone the repository and run the unified launcher:
```bash
git clone https://github.com/mahammadanish321/TEAFFIX.git
cd TEAFFIX
chmod +x start.sh
./start.sh
```

### 🪟 Option 2: Windows (1-Click Command)
Clone and double-click `start.bat` or run:
```cmd
git clone https://github.com/mahammadanish321/TEAFFIX.git
cd TEAFFIX
start.bat
```

---

## 📂 Repository Structure & Modules

| Module Directory | Role & Description | Tech Stack | Port |
|:---|:---|:---|:---|
| **[`TraffixAI-F/`](./TraffixAI-F)** | 3D Command Dashboard & Desktop Application | React Native, Expo, Electron, MapLibre 3D, TypeScript | `8081` |
| **[`trafix.backend/`](./trafix.backend)** | Central Event Gateway, Re-ID Matcher & WebSocket Hub | Node.js, Express, WebSocket (ws), REST API | `8000` |
| **[`Traffix_Ai/`](./Traffix_Ai)** | Computer Vision & ANPR Live Stream Daemon | Python 3, PyTorch, YOLOv8, ByteTrack, EasyOCR, OpenCV, FastAPI | `8002` |

---

## 🛠️ Manual Step-by-Step Setup

If you prefer launching each microservice in separate terminal windows:

### 1. Start the AI Vision Daemon (Port 8002)
```bash
cd Traffix_Ai
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python server/stream_server.py
```

### 2. Start the Central Backend (Port 8000)
```bash
cd trafix.backend
npm install
npm run dev
```

### 3. Start the 3D Desktop App (Port 8081)
```bash
cd TraffixAI-F
npm install
npm run desktop
```

---

## 🧠 Algorithmic Core & Analytics

### 1. Shortest Path & Road Routing
* **Graph Engine**: Open Source Routing Machine (OSRM) with OpenStreetMap road graph.
* **Routing Algorithm**: **Contraction Hierarchies (CH)** and **Multi-Level Dijkstra (MLD)** for `< 1 ms` shortest driving path computation.
* **Trajectory Smoothing**: **Catmull-Rom Splines** combined with **Ramer-Douglas-Peucker (RDP)** polyline simplification.

### 2. Vehicle Tracking State Machine

```mermaid
stateDiagram-v2
    direction LR
    [*] --> NEW: Initial BBox Detection
    NEW --> ACTIVE: Consecutive Hits ≥ 3
    ACTIVE --> TEMPORARILY_LOST: Missed ≤ 120 frames
    TEMPORARILY_LOST --> ACTIVE: Re-Identified
    TEMPORARILY_LOST --> ENDED: Lost > 120 frames
    ENDED --> [*]
```

---

## 👥 Team & Contributor Credits

Developed with ❤️ for **Smart India Hackathon (SIH 2026)**.

| Sl | Member Name | Role / Designation | Department | Roll Number | Year / Sem | Email |
|:---:|:---|:---|:---:|:---:|:---:|:---|
| 👑 | **Mahammad Anish** | **Team Leader** (Full-Stack & CV Architect) | CSE | `28100124030` | 3rd Yr (5th Sem) | [anish130905@gmail.com](mailto:anish130905@gmail.com) |
| ⚡ | **Soumen Pore** | Team Member | ECE | `28100324010` | 3rd Yr (5th Sem) | [soumenpore7777@gmail.com](mailto:soumenpore7777@gmail.com) |
| ⚡ | **Ranjit Bhandary** | Team Member | CSE | `28100124059` | 3rd Yr (5th Sem) | [ranjitbhandary15@gmail.com](mailto:ranjitbhandary15@gmail.com) |
| ⚡ | **Rahul Mangal** | Team Member | CSE | `28100124028` | 3rd Yr (5th Sem) | [rajupagalworld123@gmail.com](mailto:rajupagalworld123@gmail.com) |
| ⚡ | **Aviyash Yadav** | Team Member | CSE | `28100124003` | 3rd Yr (5th Sem) | [suresh.yadav4624@gmail.com](mailto:suresh.yadav4624@gmail.com) |
| ⚡ | **Shrestha Mukherjee** | Team Member | ECE | `28100324008` | 3rd Yr (5th Sem) | [shresthastudy100@gmail.com](mailto:shresthastudy100@gmail.com) |

---

## 📄 License

This project is licensed under the **MIT License** — built for evaluation under Smart India Hackathon 2026.


