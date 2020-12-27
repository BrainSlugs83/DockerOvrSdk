## Docker OVR SDK
`brainslugs83/ovrsdk` is a docker image that can be used to build APKs which target the Oculus Quest (and that require the Oculus Mobile SDK).

It may also be possible to build for other Android based VR platforms that the SDK supports, but such usage is currently untested.

### Links:
 - GitHub: https://github.com/BrainSlugs83/DockerOvrSdk
 - DockerHub: https://hub.docker.com/r/brainslugs83/ovrsdk

### Installation:
```
docker pull brainslugs83/ovrsdk
```

This may take some time to download everything, but it's much quicker than installing Android Studio and configuring a thousand other prerequisites. 😉

### Example Usage (Windows):
Here's an example showing how you can compile QuakeQuest (a popular open source project, which can be found here: https://github.com/DrBeef/QuakeQuest)

```
:: Clone the QuakeQuest Repository locally:
git clone https://github.com/DrBeef/QuakeQuest.git
cd QuakeQuest

:: Kick off a Build
docker run -it --rm -v %cd%:/proj brainslugs83/ovrsdk /opt/build.sh

:: Verify the build output
dir *.apk
```

It's that easy, no need to have anything else installed or configured!

### Example Usage (Linux):
Here's the same Example as above, but slightly modified for Linux usage:

```
:: Clone the QuakeQuest Repository locally:
git clone https://github.com/DrBeef/QuakeQuest.git
cd QuakeQuest

:: Kick off a Build
docker run -it --rm -v $(pwd):/proj brainslugs83/ovrsdk /opt/build.sh

:: Verify the build output
ls *.apk
```

### General Usage:
Just run an instance of the image with `/proj` mapped to your local project root folder and run `/opt/build.sh`; Since an absolute path is required, I recommend taking advantage of the `%cd%` environment variable.

The following command will build a project located at `D:\path\to\my\project\`:

```
pushd D:\path\to\my\project\
docker run -it --rm -v %cd%:/proj brainslugs83/ovrsdk /opt/build.sh
popd
```

When it completes, it should dump any `.apk` files produced by the build back into your local project folder.

### Building from source:

- Prerequisites: you will need `git`, and `docker` to be installed and configured.

1. Clone the repository:
   ```
   git clone https://github.com/BrainSlugs83/DockerOvrSdk.git
   cd DockerOvrSdk
   ```

2. Download the `ovr_sdk_mobile_*.zip` into the `src` folder from this site: https://developer.oculus.com/downloads/package/oculus-mobile-sdk/

3. Kick off the build
   ```
   build.bat
   ```

### Troubleshooting:

#### Case sensitive file names
Please note that this is a Linux image, and Linux has case sensitive filenames, so if you are not careful you could run into file not found issues; for example the following two includes would include different files on Linux. -- Fun times!
 - `#include "myfile.h"` 
 - `#include "MyFile.h"`

(Again, this is an example of what not to do.  It might build fine on Windows or Mac, but not on Linux...)

#### Absolute Path is Required
When running the image via the instructions above, please note that the path to the folder of your project must be an ABSOLUTE path (not a relative path) to your project, and it must encapsulate all of the files in the project structure (e.g. it must not use files from parent folders except those supplied by the OVR SDK).

If you must use a relative path, change to that directory (e.g. using `cd` or `pushd`) and use the `%cd%` environment variable (as shown in the above usage example!)