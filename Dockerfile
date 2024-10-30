FROM nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y tzdata
ENV TZ Asia/Tokyo

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

COPY environment.yaml .

RUN pip install --upgrade pip && \
    conda update -n base -c defaults conda && \
    conda env create -n paint_3d -f environment.yaml && \
    conda init && \
    echo "conda activate paint_3d" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV paint_3d && \
    PATH /opt/conda/envs/paint_3d/bin:$PATH

WORKDIR /workspace

RUN conda run -n paint_3d pip install kaolin -f https://nvidia-kaolin.s3.us-east-2.amazonaws.com/torch-1.12.1_cu116.html

CMD ["/bin/bash"]
