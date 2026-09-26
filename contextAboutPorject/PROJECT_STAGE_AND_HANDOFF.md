# Traffix AI — Project Stage & Handoff Guide

> **Smart India Hackathon (SIH 2026) | Problem Statement: PS 26127 (BEL)**  
> *City-Wide AI Engine for Multi-Camera ANPR Trajectory Tracking*  
> **Last Updated:** September 5, 2026  
> **Current Milestone:** Person 1 & Person 2 Fully Implemented & Integrated (Ready for Frontend UI Work)

---

## 📌 Executive Summary

As of this stage:
* **Person 1 (Perception & Motion Pipeline)**: ✅ **100% Completed & Verified**
  * Video/RTSP ingestion, YOLOv8 vehicle detection, BoT-SORT multi-object tracking, and local track lifecycle state machine (`NEW` $\to$ `ACTIVE` $\to$ `LOST` $\to$ `ENDED`).
* **Person 2 (Identity Intelligence — ANPR & Re-ID)**: ✅ **100% Completed & Verified**
  * License plate ROI extraction, Bilateral + CLAHE contrast enhancement, EasyOCR character extraction, Indian vehicle registration syntax correction (`Z` $\to$ `2`, `O` $\to$ `0`, `B` $\to$ `8`), and MobileNetV3 512-D normalized visual embeddings ($L_2 = 1.0$, $<15$ ms on CPU).
* **Master Pipeline Integration**: ✅ **100% Completed & Verified**
  * Person 1 and Person 2 communicate seamlessly via `VehicleObservation` $\to$ `IdentityPipeline` $\to$ `DetectionEvent`.
* **Git Status**: Clean working tree on `main` (`commit dd246e9`).

---

## 🏛️ System Architecture & Data Flow

```
┌─────────────────────────────────────────────────────────┐
│              TRAFFIX AI — AI SERVICE                    │
│                                                         │
│  [ Camera / RTSP Video ]                                │
│         │                                               │
│         ▼                                               │
│  [ Person 1: YOLO Detection + BoT-SORT Tracking ]       │
│         │                                               │
│         ▼ Emits VehicleObservation (with best_crop)     │
│  ┌───────────────────────────────────────────────────┐  │
│  │ Person 2: IdentityPipeline                        │  │
│  │ • ANPREngine: CLAHE + EasyOCR + Indian Syntax     │  │
│  │ • VehicleReIDExtractor: MobileNetV3 (512D Vector) │  │
│  └───────────────────────────────────────────────────┘  │
│         │                                               │
│         ▼ Enriched DetectionEvent (event_id, plate, emb)│
└──────────────────────────────────┬──────────────────────┘
                                   │ POST /api/v1/events/detection
                                   ▼
┌─────────────────────────────────────────────────────────┐
│            REPO 2: BACKEND (trafix.backend)             │
│   • Node.js / Express + PostgreSQL / PostGIS            │
│   • Multi-camera event persistence & pgvector indexing  │
│   • HMM Trajectory Reconstruction Engine                │
└──────────────────────────────────┬──────────────────────┘
                                   │ REST + WebSockets
                                   ▼
┌─────────────────────────────────────────────────────────┐
│            REPO 3: FRONTEND (TraffixAI-F)               │
│   • React Native + Expo + react-native-maps             │
│   • Vehicle Trajectory Playback, Heatmaps & Dashboard   │
└─────────────────────────────────────────────────────────┘
```

---

## 🧪 Completed Test Suite (All Passing ✅)

Run these anytime inside `Traffix_Ai/` to verify system health:

```bash
cd "/home/mahammadanish/Coding/TEAFFIX/Traffix_Ai"
source venv/bin/activate

# 1. Shared API Contract Schemas
python tests/test_contract.py

# 2. ANPR Preprocessing & Syntax Parser (MH1ZDE1432 -> MH12DE1432)
python tests/test_anpr.py

# 3. Vehicle Re-ID 512D Embeddings & Cosine Similarity Benchmark
python tests/test_reid.py

# 4. End-to-End Live Pipeline Integration Test
python tests/test_pipeline_e2e.py

# 5. Run Live Streaming HUD Pipeline
python main.py
```

### Verified Performance Benchmarks on CPU:
* **Re-ID Feature Extraction:** `12.9 ms` per vehicle crop (Target $<25$ ms).
* **Same Vehicle Similarity:** `0.9192` (Target $>0.85$).
* **Different Vehicle Similarity:** `0.1424` (Target $<0.50$).
* **L2 Vector Normalization:** `1.00000` (Exact unit length).

---

## 🔄 How to Resume / Rework `Traffix_Ai` Later

When you return to the AI service, follow these quick steps:

### 1. Activating the Environment
```bash
cd "/home/mahammadanish/Coding/TEAFFIX/Traffix_Ai"
source venv/bin/activate
```
*(Ensure `((venv))` appears in your terminal prompt).*

### 2. Running the Live AI Stream
```bash
python main.py
```
* **Controls:** Press **`q`** in the OpenCV window to exit.
* **Console Logs:** Outputs consolidated events (`CAM_001_T_x | Plate: ... | Emb: 512D`).
* **Visual HUD:** Displays active tracks in Green, coasting tracks in Cyan, trajectory trails in Yellow, and recognized license plates over cars.

### 3. Pending Tasks for `Traffix_Ai` (Next Steps for AI Service):
1. **Live Backend Integration Test**:
   * Start `trafix.backend` (`npm run dev`).
   * Run `python main.py` in `Traffix_Ai`.
   * Verify status changes from `Generated (Backend Offline)` to `Dispatched to Backend (202 Accepted)`.
2. **Multi-Camera Deployment**:
   * Add a secondary camera configuration in `.env` (e.g. `CAM_002`) pointing to a second video source to simulate multiple junction cameras streaming simultaneously.

---

## 🎨 Next Focus: Frontend Work in `TraffixAI-F`

You are now switching to design and build components in [`TraffixAI-F`](file:///home/mahammadanish/Coding/TEAFFIX/TraffixAI-F).

### 1. Frontend Tech Stack
* **Framework**: React Native + Expo SDK 54 + TypeScript.
* **Routing**: `expo-router` (File-based navigation under `app/`).
* **GIS Mapping**: `react-native-maps`.
* **State & Networking**: Axios.

### 2. How to Start the Frontend
```bash
cd "/home/mahammadanish/Coding/TEAFFIX/TraffixAI-F"
npm install
npx expo start --web
```
*(You can run `--web` to view directly in your browser, or scan the QR code with Expo Go on your mobile phone).*

### 3. Key Frontend Features to Design & Build:
1. **GIS City Map View**:
   * Junction camera markers (`CAM_001`, `CAM_002`) with status indicators (Online/Offline).
   * Animated vehicle trajectory paths connecting camera coordinates.
   * Traffic congestion heatmaps.
2. **Vehicle Search & Detail View**:
   * Search vehicle by license plate (e.g., `MH12DE1432`) or track ID.
   * Vehicle detail card showing:
     * License plate with confidence badge.
     * Vehicle type (Car / Bus / Truck / Motorcycle).
     * Chronological timeline of observed cameras and timestamps.
3. **Security & Alert Center**:
   * Stolen / Blacklisted plate flags.
   * Suspicious route anomalies (e.g., cloned plates spotted at two distant cameras simultaneously).
   * Live traffic statistics and camera heartbeat status.

### 4. Important Architectural Boundary:
* **The Frontend NEVER calls the AI Service directly.**
* The Frontend consumes REST APIs and WebSockets provided by the **Backend (`trafix.backend`)**.
* Keeping this clean allows you to design mock data in the frontend that directly matches the backend models!
