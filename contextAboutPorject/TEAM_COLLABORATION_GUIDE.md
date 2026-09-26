# Traffix AI — Team Collaboration & Engineering Guide
**Smart India Hackathon (SIH 2026) | PS ID: PS 26127**  
*Centralized City-Wide Multi-Camera ANPR Trajectory Tracking System*

---

## 1. Introduction & Core Principle

Traffix AI is developed by a collaborative team of 4 engineers with strictly defined feature ownership areas. 

```
┌────────────────────────────────┐
│   Repo 1: AI Service           │  • Video Feeds / RTSP (OpenCV)
│   (Perception & ANPR/Re-ID)    │  • YOLO Detection + Tracking + OCR + Embeddings
└──────────────┬─────────────────┘
               │ POST /api/v1/events/detection
               ▼
┌────────────────────────────────┐
│   Repo 2: Backend              │  • PostgreSQL / PostGIS / Vector Storage
│   (Data & Trajectory Engine)   │  • Global Vehicle Matching & HMM Trajectory Reconstruction
└──────────────┬─────────────────┘  • REST APIs & Real-Time WebSockets
               │ REST + WebSocket
               ▼
┌────────────────────────────────┐
│   Repo 3: Frontend             │  • React + TypeScript + MapLibre GIS
│   (UI / Visualization)         │  • Vehicle Trajectory Playback, Heatmaps & Dashboards
└────────────────────────────────┘
```

> **The Core System Principle:**  
> **AI produces observations.**  
> **Backend turns observations into intelligence.**  
> **Frontend turns intelligence into visual decisions.**  
> *Keeping this boundary clear allows all 4 team members to work completely in parallel without blocking one another.*

---

## 2. 4-Person Feature Ownership

| Person | Focus Area | Technology Stack | Key Responsibilities |
|---|---|---|---|
| **Person 1** | **Camera & Perception Pipeline** | OpenCV, YOLOv8/11, ByteTrack | RTSP/Video ingest, YOLO vehicle detection, multi-object tracking, local track ID generation (`CAM_001_T_x`), FPS optimization. |
| **Person 2** | **ANPR & Vehicle Re-ID** | PyTorch, OCR, Re-ID Embeddings | License plate detection, OCR parsing, visual feature embeddings, vehicle similarity matching. |
| **Person 3** | **Backend & Trajectory Engine** | FastAPI, PostgreSQL, PostGIS | Detection event storage, global vehicle identity resolution, HMM-based trajectory reconstruction, REST & WebSockets. |
| **Person 4** | **Frontend & GIS Visualization** | React, TypeScript, MapLibre GL | City GIS map, vehicle trajectory playback, traffic heatmaps, congestion indicators, real-time alert UI. |

---

## 3. Git Branching Strategy & Workflow

### A. Branch Hierarchy
* **`main`**: The single source of truth. Always stable, fully tested, and deployable. **Direct commits to `main` are strictly forbidden.**
* **`feat/...`**: Feature branches for new capabilities.
* **`fix/...`**: Bug fix branches.
* **`test/...`**: Dedicated test additions.
* **`docs/...`**: Documentation updates.

### B. Branch Naming Rules
```bash
feat/camera-stream-wrapper
feat/yolo-vehicle-detection
feat/bytetrack-noise-filter
feat/anpr-ocr-model
fix/tracker-id-switching
docs/update-collaboration-guide
```

### C. Daily Step-by-Step Git Routine

```
1. Sync main branch
   git checkout main
   git pull origin main

2. Create a new feature branch
   git checkout -b feat/<your-feature-name>

3. Implement your changes & run tests locally
   python tests/test_contract.py
   python tests/test_tracking.py

4. Stage & Commit using Conventional Commits
   git add .
   git commit -m "feat(scope): concise description of changes"

5. Push to GitHub
   git push -u origin feat/<your-feature-name>

6. Open a Pull Request (PR) on GitHub
```

---

## 4. Conventional Commit Standard

All commits must follow the **Conventional Commits** specification:

```
<type>(<scope>): <short description in present tense>
```

### Commit Types:
* **`feat`**: A new feature for the user or system (`feat(camera): add RTSP reconnect logic`).
* **`fix`**: A bug fix (`fix(tracker): prevent ID switching on fast vehicles`).
* **`refactor`**: Code restructuring without changing functional behavior (`refactor(stream): simplify frame generator`).
* **`perf`**: Performance improvement (`perf(yolo): enable batch inference for 40+ FPS`).
* **`test`**: Adding or updating unit tests (`test(contract): validate heartbeat schema`).
* **`docs`**: Documentation only (`docs(readme): add team ownership matrix`).
* **`chore`**: Dependency updates, `.gitignore`, build tools (`chore: bump pydantic version`).

---

## 5. API Contracts & The Single Source of Truth

The contract between AI and Backend is strictly defined in `schemas/`:

### A. Detection Event (`POST /api/v1/events/detection`)
```json
{
  "camera_id": "CAM_001",
  "observed_at": "2026-08-31T10:30:20Z",
  "local_track_id": "CAM_001_T_73",
  "vehicle_type": "car",
  "plate_number": "WB12AB1234",
  "plate_confidence": 0.94,
  "vehicle_embedding": [0.012, -0.084, 0.221],
  "embedding_model": "reid-model-v1",
  "embedding_version": "1.0",
  "vehicle_confidence": 0.91,
  "bounding_box": {
    "x1": 412,
    "y1": 220,
    "x2": 690,
    "y2": 530
  }
}
```

### B. Camera Heartbeat (`POST /api/v1/cameras/{camera_id}/heartbeat`)
```json
{
  "status": "online",
  "fps": 24.0,
  "processing_latency_ms": 42.0
}
```

### C. Contract Rule:
> **Never modify fields in `schemas/` without an approved team discussion.**  
> If an AI developer silently changes `camera_id` to `cam_id`, the Backend and Frontend will instantly break.

---

## 6. Pull Request (PR) & Code Review Process

### A. Pull Request Checklist (For the Author)
Before clicking "Create Pull Request":
- [ ] Code is formatted and clean.
- [ ] No hardcoded passwords, tokens, or private RTSP credentials.
- [ ] All local tests pass (`python tests/test_contract.py`).
- [ ] PR description explains **What changed**, **Why**, and **How it was tested**.

### B. Reviewer Responsibilities (For Teammates)
1. **Automated CI**: Verify that GitHub Actions CI shows a **Green Checkmark (✅)**.
2. **Contract Integrity**: Check that no shared data models were broken.
3. **Logic Review**: Check error handling (`try/except`), boundary checks, and resource releases (`cap.release()`).
4. **Merge Method**: Always use **"Squash and Merge"** on GitHub to keep `main` git history clean and readable.

---

## 7. Continuous Integration (CI) & Quality Rules

### A. What CI Catches Automatically:
* Syntax errors and code crashes.
* Missing Python packages in `requirements.txt`.
* Pydantic schema validation failures.
* Broken imports and unhandled exceptions.

### B. How to Handle a Failing PR (Red ❌ in CI):
1. **Do NOT merge a failing branch into `main`**.
2. Review the GitHub Actions failure log to find the exact line and error.
3. Push a fix commit directly to the existing feature branch.
4. GitHub will automatically re-run the tests. Once **Green ✅**, the PR can be merged.

---

## 8. Onboarding Guide for New Contributors

### Step 1: Clone and Navigate
```bash
git clone https://github.com/mahammadanish321/TraffixAI-ai.git
cd TraffixAI-ai
```

### Step 2: Create Python 3.12 Virtual Environment
```bash
python3.12 -m venv venv
source venv/bin/activate
```

### Step 3: Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Step 4: Validate Setup
```bash
# Test API Contract Schemas
python tests/test_contract.py

# Test Camera / Video Ingestion
python tests/test_camera.py

# Test Vehicle Tracking
python tests/test_tracking.py

# Run Master AI Pipeline
python main.py
```

---

## 9. Golden Rules Summary

1. **Keep `main` always green and working.**
2. **One feature per branch; one review per merge.**
3. **Code on CPU first, optimize for GPU second.**
4. **Never commit large video files or AI weight checkpoints to Git.**
5. **When in doubt, communicate and test the contract.**
