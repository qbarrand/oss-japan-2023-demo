FROM quay.io/jupyter/base-notebook

USER root

RUN apt update && \
  apt install -y gpg-agent git wget && \
  apt clean

RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy/production/2328 unified" > /etc/apt/sources.list.d/intel-gpu-jammy.list
RUN apt update && \
  apt install -y \
  intel-opencl-icd intel-level-zero-gpu level-zero \
  intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
  libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
  libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers \
  mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all vainfo hwinfo clinfo \
  libglib2.0-0 kmod && \
  apt clean

USER jovyan

RUN pip install --no-cache-dir "optimum-intel[openvino,diffusers]>=1.12.1" "ipywidgets" "transformers>=4.33" --extra-index-url https://download.pytorch.org/whl/cpu

RUN mkdir -p /home/jovyan/.cache/huggingface
