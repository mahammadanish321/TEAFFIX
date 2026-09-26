#!/usr/bin/env bash

# ==============================================================================
#                      TRAFFIX AI - 1-CLICK SYSTEM LAUNCHER
#                  Smart India Hackathon (SIH 2026) Prototype
# ==============================================================================

set -e

# ANSI Color Codes
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RED='\033[1;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}==============================================================================${NC}"
echo -e "${GREEN}                 TRAFFIX AI — SMART TRAFFIC & ANPR ECOSYSTEM                 ${NC}"
echo -e "${YELLOW}                  Smart India Hackathon (SIH 2026) Prototype                  ${NC}"
echo -e "${CYAN}==============================================================================${NC}"
echo ""

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cleanup() {
  echo ""
  echo -e "${RED}🛑 Gracefully stopping all Traffix AI services...${NC}"
  kill $(jobs -p) 2>/dev/null || true
  pkill -f "stream_server.py" 2>/dev/null || true
  echo -e "${GREEN}✔ All services stopped.${NC}"
  exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# 1. Start AI Stream Server Daemon (Port 8002)
echo -e "${BLUE}🧠 [1/3] Starting Edge AI Vision Daemon (Port 8002)...${NC}"
cd "$ROOT_DIR/Traffix_Ai"
if [ -f "./venv/bin/python" ]; then
  PYTHON_EXE="./venv/bin/python"
elif command -v python3 &>/dev/null; then
  PYTHON_EXE="python3"
else
  PYTHON_EXE="python"
fi

$PYTHON_EXE server/stream_server.py > /tmp/traffix_ai_daemon.log 2>&1 &
AI_PID=$!
echo -e "   ${GREEN}✔ AI Daemon launched (PID: $AI_PID, Port: 8002)${NC}"

# 2. Start Backend Server (Port 8000)
echo -e "${BLUE}⚙️  [2/3] Starting Central Backend Gateway (Port 8000)...${NC}"
cd "$ROOT_DIR/trafix.backend"
npm run dev > /tmp/traffix_backend.log 2>&1 &
BACKEND_PID=$!
echo -e "   ${GREEN}✔ Backend Gateway launched (PID: $BACKEND_PID, Port: 8000)${NC}"

# 3. Start Frontend App (Port 8081 & Electron)
echo -e "${BLUE}💻 [3/3] Starting 3D Digital Twin Command Center (Electron / Port 8081)...${NC}"
cd "$ROOT_DIR/TraffixAI-F"
echo -e "${GREEN}==============================================================================${NC}"
echo -e "${GREEN}🚀 All 3 services are active! Launching Desktop GUI...${NC}"
echo -e "${CYAN}   - Edge AI Stream Daemon: http://localhost:8002${NC}"
echo -e "${CYAN}   - Central REST & WS API: http://localhost:8000${NC}"
echo -e "${CYAN}   - 3D Digital Twin UI:    http://localhost:8081 / Native Desktop${NC}"
echo -e "${GREEN}==============================================================================${NC}"

npm run desktop

wait
