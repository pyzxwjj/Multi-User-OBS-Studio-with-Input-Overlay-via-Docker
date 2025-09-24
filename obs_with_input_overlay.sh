xhost +local:docker
docker run --rm -it \
    --name "obs-container-$USER" \
    --ipc=host \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/passwd:/etc/passwd:ro -v /etc/group:/etc/group:ro \
    -v $HOME/obsuser:$HOME \
    -u $(id -u):$(id -g) \
    -w $HOME \
    -e TZ=Asia/Shanghai \
    -e USER=$USER \
    --entrypoint obs obs_with_input_overlay

    # -v /home/wjj/:/home/wjj/ \
    # -v /run/user/$(id -u)/pulse:/run/user/1000/pulse \
    # --privileged \
    # -v obs-config:/home/obsuser/.config/obs-studio \
    # --device /dev/dri:/dev/dri \
    # --device /dev/video0:/dev/video0 \
    # --- GUI Forwarding (X11) ---
    # --- Device Access ---
    # --- Audio Forwarding (PulseAudio) ---
    # --- Persist OBS Configuration ---
