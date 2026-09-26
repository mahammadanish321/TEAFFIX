@echo off
title Traffix AI - 1-Click System Launcher
color 0A

echo ==============================================================================
echo                      TRAFFIX AI - SMART CITY ECOSYSTEM
echo                  Smart India Hackathon (SIH 2026) Prototype
echo ==============================================================================
echo.

set ROOT_DIR=%~dp0

:: 1. Start AI Daemon (Port 8002)
echo [1/3] Starting Traffix_Ai Edge Vision Daemon (Port 8002)...
cd /d "%ROOT_DIR%Traffix_Ai"
if exist venv\Scripts\python.exe (
    start "Traffix AI - Vision Daemon (8002)" cmd /k "venv\Scripts\python.exe server\stream_server.py"
) else (
    start "Traffix AI - Vision Daemon (8002)" cmd /k "python server\stream_server.py"
)

:: 2. Start Backend API & WebSocket Gateway (Port 8000)
echo [2/3] Starting Central Backend Gateway (Port 8000)...
cd /d "%ROOT_DIR%trafix.backend"
start "Traffix AI - Central Backend (8000)" cmd /k "npm run dev"

:: 3. Start 3D Desktop Dashboard (Port 8081 / Electron)
echo [3/3] Starting 3D Digital Twin Command Center...
cd /d "%ROOT_DIR%TraffixAI-F"
start "Traffix AI - Command Dashboard" cmd /k "npm run desktop"

echo.
echo ==============================================================================
echo  All 3 Traffix AI services are launching concurrently!
echo  - Edge Vision Daemon: http://localhost:8002
echo  - Central Backend API: http://localhost:8000
echo  - 3D Digital Twin UI:  http://localhost:8081 / Electron App
echo ==============================================================================
echo.
pause
