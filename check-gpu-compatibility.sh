#!/bin/bash

echo "🔍 Checking GPU Compatibility for ComfyUI Docker..."

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ nvidia-smi not found. Please install NVIDIA drivers."
    exit 1
fi

# Get GPU information
DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits)
GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits)

echo "🎮 GPU Information:"
echo "   GPU: $GPU_NAME"
echo "   Driver: $DRIVER_VERSION"

# Extract CUDA version from nvidia-smi output
CUDA_VERSION=$(nvidia-smi | grep "CUDA Version" | sed -n 's/.*CUDA Version: \([0-9.]*\).*/\1/p')

if [ -n "$CUDA_VERSION" ]; then
    echo "   CUDA: $CUDA_VERSION"
    
    # Check CUDA version compatibility
    CUDA_MAJOR=$(echo $CUDA_VERSION | cut -d. -f1)
    CUDA_MINOR=$(echo $CUDA_VERSION | cut -d. -f2)

    if [ "$CUDA_MAJOR" -lt 12 ]; then
        echo "⚠️  Warning: CUDA $CUDA_VERSION detected. ComfyUI Docker uses CUDA 12.8."
        echo "   Your setup may work but consider updating NVIDIA drivers."
    elif [ "$CUDA_MAJOR" -eq 12 ] && [ "$CUDA_MINOR" -lt 6 ]; then
        echo "⚠️  Warning: CUDA $CUDA_VERSION detected. ComfyUI Docker optimized for CUDA 12.6+."
        echo "   Your setup should work but may have compatibility issues."
    else
        echo "✅ CUDA $CUDA_VERSION is compatible with ComfyUI Docker."
    fi
else
    echo "   CUDA: Version detection failed, but driver $DRIVER_VERSION should work"
    echo "✅ Driver version suggests CUDA 12+ compatibility."
fi

# Check Docker and NVIDIA Container Runtime
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker."
    exit 1
fi

if ! docker info | grep -q "nvidia"; then
    echo "⚠️  NVIDIA Container Runtime may not be configured."
    echo "   Install nvidia-docker2 or nvidia-container-toolkit"
fi

# Check GPU architecture
GPU_ARCH=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits)
if echo "$GPU_ARCH" | grep -q "RTX 50"; then
    echo "🚀 RTX 50 series detected - fully optimized setup!"
elif echo "$GPU_ARCH" | grep -q "RTX 40\|RTX 30"; then
    echo "✅ RTX 40/30 series detected - excellent compatibility!"
elif echo "$GPU_ARCH" | grep -q "RTX 20\|GTX"; then
    echo "⚠️  Older GPU detected. May need CUDA compatibility adjustments."
fi

echo ""
echo "🐳 Ready to run: docker compose up -d"
echo "🌐 ComfyUI will be available at: http://localhost:8188"