FROM nvidia/cuda:12.6.1-runtime-ubuntu22.04

# Install Python and system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Install Python dependencies
WORKDIR /app/ComfyUI

# Install PyTorch with CUDA 12.8 support (compatible with RTX 40/50 series)
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

# Install ComfyUI requirements
RUN pip3 install -r requirements.txt

# Set CUDA environment variables for better compatibility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV CUDA_VISIBLE_DEVICES=0

# Expose port
EXPOSE 8188

# Copy and make startup script executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start ComfyUI with GPU verification
CMD ["/start.sh"]