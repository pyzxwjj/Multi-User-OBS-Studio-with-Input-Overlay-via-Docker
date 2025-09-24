# Multi-User OBS Studio with Input Overlay via Docker

A containerized solution to run OBS Studio with the `input-overlay` plugin on a shared Ubuntu server, enabling multiple users to record simultaneously without conflicts.

## The Problem

When multiple users are logged into a single Ubuntu server (e.g., via XRDP), running OBS Studio with the popular `input-overlay` plugin presents a major challenge. The plugin's WebSocket server defaults to a fixed port (`16899`, you can change it, but it reverts to 16899 after restarting). If one user is using it, no other user on the same machine can, as the port is already occupied. This makes it impossible for multiple users to record their keyboard or mouse inputs at the same time.

## The Solution

This project leverages **Docker's network isolation** to solve the problem elegantly. By running each user's OBS Studio instance inside its own dedicated Docker container, every instance gets its own isolated network stack.

This means each container can run the `input-overlay` WebSocket server on the default port `16899` without interfering with any other user's instance.

## Features

-   **Isolated OBS Environment**: Prevents port conflicts and dependency issues between users.
-   **Pre-configured `input-overlay`**: The Docker image comes with the `input-overlay` plugin, a sample scene configuration, and an HTML file to display keyboard presses out-of-the-box.
-   **Multi-User Ready**: Designed from the ground up for shared server environments.
-   **Persistent Configuration**: User-specific OBS settings and plugin data are stored in the user's home directory on the host machine, persisting across container restarts.
-   **Simplified Startup**: A helper script (`obs_with_input_overlay.sh`) is provided to handle the complex Docker command and ensure correct permissions.

## Prerequisites

Before you begin, ensure you have the following installed on your Ubuntu server:

-   [Docker Engine](https://docs.docker.com/engine/install/ubuntu/)
-   Your user account must be part of the `docker` group to run Docker commands without `sudo`.
    ```bash
    sudo usermod -aG docker $USER
    # You will need to log out and log back in for this change to take effect.
    ```
-   An X11 server (standard on desktop environments and available via XRDP).

## Quick Start Guide

1.  **Clone the Repository**
    ```bash
    git clone <your-repository-url>
    cd <your-repository-name>
    ```

2.  **Build the Docker Image**
    This command builds the Docker image using the provided `Dockerfile`. It will install OBS, its dependencies, and the `input-overlay` plugin.
    ```bash
    docker build -t obs_with_input_overlay .
    ```

3.  **Copy the Initial Configuration**
    This project includes a template directory (`obsuser`) containing the pre-configured OBS profile and the `input-overlay` files. Copy this to your home directory. This will be your personal, persistent storage for all OBS settings.
    ```bash
    cp -r obsuser/ $HOME/
    ```
    **Note**: This directory will be mounted into the container, so any changes you make in OBS will be saved here.

4.  **Run the Container**
    Execute the provided shell script to start the OBS container.
    ```bash
    ./obs_with_input_overlay.sh
    ```
    The script handles mounting all necessary volumes (for display, audio, and configuration) and setting the correct environment variables.

5.  **Handling Permissions (Important!)**
    The first time you run the script, you might see permission-related errors from Docker. This is because the files you copied in step 3 are owned by the user who created them, not necessarily your current user ID inside the container.

    The startup script attempts to fix this automatically. If you still encounter issues, you can manually set the correct ownership on the host machine:
    ```bash
    sudo chown -R $(id -u):$(id -g) $HOME/obsuser
    ```

You should now see the OBS Studio window appear, fully configured with the input overlay ready to use!

## How It Works: Plugin Installation

You can install input-overlay deb package using dpkg.

In this project, the `input-overlay` plugin is not installed via a package manager. Instead, the `.deb` package is manually extracted (as [Manually installing plugins on linux](https://vrsal.cc/issues/linux/)) within the `Dockerfile`. This method provides fine-grained control and ensures the plugin files are placed correctly within the user-specific configuration directory that will be mounted.

The installation process inside the Dockerfile follows these steps:

```bash
# 1. Extract the .deb archive to a temporary directory
dpkg -x input-overlay-5.0.3-linux-x86_64.deb input-overlay

# 2. Create the necessary plugin structure in the user's future config directory
# Note: At build time, $HOME is the root user's home. This gets mapped later.
mkdir -p ~/.config/obs-studio/plugins/input-overlay/bin/64bit
mkdir -p ~/.config/obs-studio/plugins/input-overlay/data

# 3. Copy the plugin's shared library (.so file)
cp input-overlay/usr/lib/x86_64-linux-gnu/obs-plugins/input-overlay.so ~/.config/obs-studio/plugins/input-overlay/bin/64bit/

# 4. Copy the plugin's data files (like UI definitions)
cp -r input-overlay/usr/share/obs/obs-plugins/input-overlay/* ~/.config/obs-studio/plugins/input-overlay/data/
```
