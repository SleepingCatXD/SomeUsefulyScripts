#!/bin/bash

# Check Python 3.13
if ! command -v python3.13 &> /dev/null; then
    echo "Error: python3.13 not found. Please install Python 3.13."
    exit 1
fi

# Clone repository if not exist.
if [ ! -d "./ComfyUI" ]; then
    echo "Clone ComfyUI repository..."
    git clone https://github.com/Comfy-Org/ComfyUI.git || { echo "Error: Clone failed."; exit 1; }
fi

cd ./ComfyUI || { echo "Error: Failed to enter ComfyUI directory."; exit 1; }

echo "Create Python venv."
python3.13 -m venv ./venv
source ./venv/bin/activate || { echo "Error: Failed to activate venv."; exit 1; }
pip install --upgrade pip
pip install xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu130 || { echo "Error: Failed to install pytorch."; exit 1; }
pip install -r requirements.txt || { echo "Error: Failed to install requirements."; exit 1; }

echo "Create run and update scripts."

echo "#!/bin/bash" > run_gpu.sh
echo "source venv/bin/activate" >> run_gpu.sh
echo "python main.py --preview-method auto --listen" >> run_gpu.sh
chmod +x run_gpu.sh

echo "#!/bin/bash" > run_cpu.sh
echo "source venv/bin/activate" >> run_cpu.sh
echo "python main.py --preview-method auto --cpu --listen" >> run_cpu.sh
chmod +x run_cpu.sh

echo "#!/bin/bash" > update.sh
echo "git pull --rebase || { echo \"Error: Update repository failed\"; exit 1; }" >> update.sh
echo "source venv/bin/activate" >> update.sh
echo "pip install -r requirements.txt || { echo \"Error: Failed to install requirements\"; exit 1; }" >> update.sh
echo "echo \"=====Update Complete.=====\"" >> update.sh
chmod +x update.sh

echo "=====Installation Complete.====="
