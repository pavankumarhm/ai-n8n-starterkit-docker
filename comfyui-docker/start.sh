#!/bin/bash

echo "🚀 Starting ComfyUI with GPU verification..."

# Check NVIDIA driver
if ! nvidia-smi &> /dev/null; then
    echo "❌ NVIDIA driver not found. Please install NVIDIA drivers."
    exit 1
fi

echo "✅ NVIDIA driver detected"

# Check CUDA availability in Python
python3 -c "
import torch
print(f'PyTorch version: {torch.__version__}')
print(f'CUDA available: {torch.cuda.is_available()}')
if torch.cuda.is_available():
    print(f'CUDA version: {torch.version.cuda}')
    print(f'GPU count: {torch.cuda.device_count()}')
    print(f'GPU name: {torch.cuda.get_device_name(0)}')
    print('✅ GPU setup successful')
else:
    print('❌ CUDA not available')
    exit 1
"

# Start ComfyUI
echo "🎨 Launching ComfyUI..."
cd /app/ComfyUI
python3 main.py --listen 0.0.0.0 --port 8188