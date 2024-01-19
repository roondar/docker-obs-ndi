FROM accetto/ubuntu-vnc-xfce-g3

# for the VNC connection
EXPOSE 5901  
# for the browser VNC client
EXPOSE 6901 
# for the obs-websocket plugin
EXPOSE 4455


# Use environment variable to allow custom VNC passwords
ENV VNC_PASSWD=headless

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# Make sure the dependencies are met
RUN echo headless | sudo -S -k apt update \
	&& echo headless | sudo -S -k apt install -y --fix-broken avahi-daemon xterm git build-essential cmake curl ffmpeg git libboost-dev libnss3 mesa-utils qtbase5-dev strace x11-xserver-utils net-tools python3 python3-numpy scrot wget software-properties-common vlc jq udev unrar qt5-image-formats-plugins \
	&& echo headless | sudo -S -k sed -i 's/geteuid/getppid/' /usr/bin/vlc 
RUN echo headless | sudo -S -k add-apt-repository ppa:obsproject/obs-studio \
	&& echo headless | sudo -S -k mkdir -p /config/obs-studio /root/.config/ \
	&& echo headless | sudo -S -k ln -s /config/obs-studio/ /root/.config/obs-studio \
	&& echo headless | sudo -S -k apt install -y obs-studio \
	&& echo headless | sudo -S -k apt clean -y 
RUN wget -q -O /tmp/obs-ndi.deb https://github.com/obs-ndi/obs-ndi/releases/download/4.13.0/obs-ndi-4.13.0-x86_64-linux-gnu.deb \
 	&& echo headless | sudo -S -k dpkg -i /tmp/obs-ndi.deb 
RUN wget -q  -O /tmp/libndi-get.sh https://raw.githubusercontent.com/obs-ndi/obs-ndi/master/CI/libndi-get.sh \
	&& echo headless | sudo -S -k chmod +x /tmp/libndi-get.sh \
	&& echo headless | sudo -S -k /tmp/libndi-get.sh

RUN echo headless | sudo -S -k rm -rf /tmp/*.deb \
	&& echo headless | sudo -S -k rm -rf /var/lib/apt/lists/* 

VOLUME ["/config"]
