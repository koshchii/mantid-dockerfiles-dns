## Building Mantid in Docker with Conda

1. Prepare Mantid enviroment on your host machine for linking it with a docker container. Specifically, create 3 following folders on your host machine:

* `mantid_src`
* `mantid_build`
* `mantid_data`

2. Clone the latest version of the DNS development branch of Mantid into your `mantid_src` folder, e.g:

```
git clone --branch dns_gui_powder_elastic_dev https://github.com/koshchii/mantid.git mantid_src
```     

3. Copy the `UbuntuFocalConda.Dockerfile`, `entrypoint.d` folder and all the bash scripts from this folder into your host machine, or just simply clone them from my remote on GitHub:

```
git clone https://github.com/koshchii/mantid-dockerfiles-dns.git
```

4. Run the `build_image_with_conda.sh` script (you might need to add execution permissions to all the bash scripts, including those inside the entrypoin.d folder; use `chmod ugo+x *.sh` for that).  It will create a Docker image (Ubuntu 20.04) with Conda and all the necessary libraries pre-installed. 

5. Execute the `run_conda_container.sh` script. It will create and run a Docker container from the `ubuntuconda` Docker image created in the step 4. The container will contain three directories `/mantid_src`, `/mantid_build` and `/mantid_data`. These directories will be linked to the corresponding folders on your host machine. To execute the script, run

```
./run_conda_container.sh ubuntuconda path_to_mantid_src_on_host/ path_to_mantid_build_on_host/ path_to_mantid_data_on_host/
```

If everything was set up properly, your `/mantid_src` folder inside the Docker container will already countain all the source files necessary for building Mantid inside the container. Unfortunately, I could not create a Docker image with a Mantid build already included in the image, because I was not able to find a way to include a pre-installed Conda and create a mantid-development Conda enviroment after that inside the image creation process. The reason for that is because Conda's initialization happens only in container's entrypoint. As a result, one needs to build Mantid after the Docker container has been created.

6. Your running container will be started from the `/mantid_build` working directory. Now, you need to build Mantid inside the container with the help of Conda. In general, the building process is summarized in [Mantid's documentation](https://developer.mantidproject.org/GettingStarted/GettingStartedCondaLinux.html#gettingstartedcondalinux). Below, is a brief summary of relevant steps:

- Set up the mantid-developer Conda environment:

```
conda env create -f ../mantid_src/mantid-developer-linux.yml
``` 

- Activate the created environment:

```
conda activate mantid-developer
```

- Generate build files in the current `mantid_build` folder:

```
cmake ../mantid_src/ --preset=linux -B .
```

- Build Mantid with ninja:

```
ninja -j [Njobs]
```

7. After Mantid has been built inside your Docker container, execute the Mantid Workbench by running `./bin/workbench` inside the container. This will run the workbench, from which the [DNS Reduction](https://docs.mantidproject.org/nightly/interfaces/direct/dns_reduction/DNS%20Reduction.html) GUI can be executed.
