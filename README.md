# debian
Debian image builder ( Uses yocto's Kernel & Modules )

1. create source dir
    ``` bash
    mkdir -p $HOME/work
    cd $HOME/work
    ```

2. clone Debian builder
    ``` bash
    git clone https://github.com/Vekatech/debian.git
    cd debian
    ```

3. build Debian image (Bookworm)
    ``` bash
    chmod a+x build.sh
    ./build.sh <board>_debian.yaml
    ```
