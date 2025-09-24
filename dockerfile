
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ENV QT_X11_NO_MITSHM=1

RUN apt-get update && apt-get install -y \
    software-properties-common \
    gnupg \
    wget \
    ffmpeg \
    v4l-utils \
    pulseaudio-utils 

RUN add-apt-repository ppa:obsproject/obs-studio && \
    apt-get update && \
    apt-get install -y obs-studio

    
RUN sed -i 's#//[^/]*ubuntu.com#//mirrors.tuna.tsinghua.edu.cn#g' /etc/apt/sources.list && apt update && apt install -y software-properties-common gnupg wget curl ca-certificates unzip build-essential cmake git pkg-config libx11-6 libx11-xcb1 libxcb1 libxcb-shm0 libxcb-glx0 libxcb-xinerama0 libxfixes3 libxrandr2 libxcomposite1 libxdamage1 libxinerama1 x11-xserver-utils libxt6 libwayland-client0 libwayland-cursor0 libwayland-egl1 libgl1-mesa-glx libgl1-mesa-dri mesa-va-drivers mesa-vdpau-drivers libqt6core6 libqt6gui6 libqt6widgets6 libqt6network6 libqt6svg6 qt6-base-dev qt6-base-private-dev qt6-wayland qt6-image-formats-plugins ffmpeg libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libswscale-dev libswresample-dev libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libpulse0 pulseaudio-utils libasound2 libasound2-dev v4l-utils libv4l-dev pipewire libpipewire-0.3-dev libspa-0.2-bluetooth libjansson4 libjansson-dev libcurl4 libcurl4-openssl-dev fonts-noto-color-emoji fonts-freefont-ttf libfontconfig1 libfreetype6
RUN apt install -y fonts-noto-cjk fonts-wqy-zenhei 

# RUN wget https://github.com/univrsal/input-overlay/releases/download/v5.0.3/input-overlay-5.0.3-linux-x86_64.deb && \
#     dpkg -i input-overlay-5.0.3-linux-x86_64.deb

# USER obsuser

# WORKDIR /home/obsuser

CMD ["obs"]