
# S2I builder image for Ansible-Playbook-Bundle

## Overview
This is a [Source-to-Image](https://docs.openshift.org/latest/architecture/core_concepts/builds_and_image_streams.html#source-build)
builder image for [Ansible Playbook Bunders (APBs)](https://github.com/fusor/ansible-playbook-bundle)

## Known Issues

### Local APB Source Files Only
Git URL will only work if the APB source is at the top level.  The Git repo such as the  [apb-examples](https://github.com/fusor/apb-examples) will not work because it's a collection of APB sources.

Similarly, the URL such as [apb-examples/hello-world-apb](https://github.com/fusor/apb-examples/tree/master/hello-world-apb)
will also not work because the `hello-world-apb` is not its own repo.

### Manual Spec File LABEL Update
Manual update of the APB's spec file encoded `LABEL` value is required.  Each APB is unique in that it has its spec file, which is base64 encoded as a LABEL.  Currenlty `s2i` does not support specifying a custom LABEL during the `assemble` step.  Therefore a manual script must be ran to update the created APB image.

## Index
  * [Quick Start](#quick-start)
  * [Creating the builder image](#creating-the-builder-image)
  * [Creating the APB image](#creating-the-apb-image)
    * [Manual Steps](#manual-steps)
    * [Using a script](#using-a-script)
  * [Running the APB image](#running-the-apb-image)

## Quick start
  * Run the `make` to create the builder image `s2i-apb`
  * Have the source code of an APB available locally
  * Run the `s2i build <path-to-APB-src> s2i-apb <APB-image>`
  * Update the spec file label via script `utils/update-apb-label.sh <path-to-APB-spec> <APB-image>`
  * Run the docker image with `docker run ...`

## Files and Directories  
| File                   | Required? | Description                                                  |
|------------------------|-----------|--------------------------------------------------------------|
| Dockerfile             | Yes       | Defines the base builder image                               |
| s2i/bin/assemble       | Yes       | Script that builds the APB                           |
| s2i/bin/usage          | No        | Script that prints the usage of the builder                  |
| s2i/bin/run            | Yes       | Script that runs the APB                             |
| s2i/bin/save-artifacts | No        | Script for incremental builds that saves the built artifacts |
| test/run               | No        | Test script for the builder image                            |
| test/test-app          | Yes       | Test APB source code  (hello-world)                               |

### Dockerfile
Create a *Dockerfile* that installs all of the necessary tools and libraries that are needed to build and run our APB.  This file will also handle copying the s2i scripts into the created image.

### S2I scripts
#### assemble
- Copy over the APB's action files
- Copying over the APB's Ansible roles folder

#### run
This is not needed for APBs

#### save-artifacts (N/A)
This is not needed for APBs

#### usage (optional)
will print out instructions on how to use the image.

## Creating the builder image
To create a builder image for APB run `make` in the folder.
```bash
$ cd s2i-apb
$ make
```
Note: you should only have to do this ONCE since this base image will not change in your APB development work flow.  Also, you can skip creating the docker image and use the [docker.io/ansibleplaybookbundle/s2i-apb](https://hub.docker.com/r/ansibleplaybookbundle/s2i-apb/) image.

## Creating the APB image

## Manual Steps
### Build APB Image
The APB image combines the builder image with your APB source code, which is served using whatever application is installed via the *Dockerfile*, compiled using the *assemble* script

The following command will create the `hello-world` APB image in the `test` folder:
```bash
$ s2i build test/test-app s2i-apb hello-s2i-test-apb

or

$ s2i build test/test-app docker.io/ansibleplaybookbundle/s2i-apb hello-s2i-test-apb
```

The *assemble* script of `s2i` will create an APB image using the builder image (s2i-apb) as a base and including the necessary files from the test/test-app directory.

### Update the Spec File LABEL
In order to update the spec file LABEL, do the follwoing

Navigate to the `utils` folder, and run the `update-apb-label.sh` script as follows:
```bash
$ cd utils
$ ./update-apb-label.sh ../test/test-app/apb.yml hello-s2i-test-apb
```

## Using a script
You may use the `s2i-build-apb.sh` script in to automate the build and the update-label process by running the following command
```bash
$ cd utils
$ ./s2i-build-apb.sh ../test/test-app hello-s2i-test-apb
```

## Running the APB image
You may run the APB image by the `docker run` command.  However you will need to have your own OpenShift environment.

For example, the below command will run the `provision` action of the `hello-s2i-test-apb` with the following environment variables.
  * OpenShift URL       : `https://172.17.0.1.nip.io:8443`
  * OpenShift User      : john
  * OpenShift Pwd       : pass
  * OpenShift Namespace : hello-world (via `--extra-vars`)

```
$ docker run \
--entrypoint /usr/bin/entrypoint.sh \
-e "OPENSHIFT_TARGET=https://172.17.0.1.nip.io:8443" \
-e "OPENSHIFT_USER=john" \
-e "OPENSHIFT_PASS=pass"  \
   hello-s2i-test-apb \
   provision \
   --extra-vars 'namespace=hello-world'
```
