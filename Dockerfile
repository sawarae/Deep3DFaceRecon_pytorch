FROM sawarae/miniconda:cuda121

# for nvdiffrast
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    pkg-config \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    libglvnd-dev \
    libgl1-mesa-dev \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    cmake \
    curl

# for GLEW
ENV LD_LIBRARY_PATH /usr/lib64:$LD_LIBRARY_PATH

# Default pyopengl to EGL for good headless rendering support
ENV PYOPENGL_PLATFORM egl

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY environment.yml .
RUN conda env create -f environment.yml && \
    conda init && \
    echo "conda activate deep3d_pytorch" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV deep3d_pytorch && \
    PATH /opt/conda/envs/deep3d_pytorch/bin:$PATH

SHELL ["conda", "run", "-n", "deep3d_pytorch", "/bin/bash", "-c"]

RUN pip install --upgrade pip
RUN pip install ninja imageio imageio-ffmpeg

RUN apt install -y git
RUN git clone https://github.com/NVlabs/nvdiffrast
WORKDIR /workspace/nvdiffrast
RUN pip install .
WORKDIR /workspace