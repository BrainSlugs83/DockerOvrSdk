# Oculus Quest Native SDK
# Used for building any of the "VrSamples" based projects.

# USAGE:
#   docker run -it --rm -v D:\projects.git\ovr\VrSamples\VrController:/proj brainslugs83/ovrsdk /opt/build.sh

FROM thyrlian/android-sdk:latest
LABEL maintainer "brainslugs83@gmail.com"

ENV _JAVA_OPTIONS -XX:+UseContainerSupport

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends make dos2unix && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# Downgrade to Gradle 4.4; 5.x causes issues with the OVR SDK templates.
ARG GRADLE_VERSION=4.4
RUN cd /opt && \
    rm -rf gradle && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle*.zip && \
    mv gradle-${GRADLE_VERSION} gradle && \
    rm gradle*.zip

# Install Android SDK
# specifically don't include "platforms;android-29" / "build-tools;29.0.1" -- it will just download
# different versions below when we call build.sh (and if you include those, it downloads something else. 🤷)
RUN cd ${ANDROID_HOME}/tools/bin && \
    sdkmanager --update && \
    sdkmanager "lldb;3.1" "ndk-bundle" "cmake;3.10.2.4988404" "platform-tools"

ENV PATH=${PATH}:${JAVA_HOME}/bin
ENV ANDROID_NDK=${ANDROID_HOME}/ndk-bundle
ENV ANDROID_NDK_ROOT=${ANDROID_HOME}/ndk-bundle
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk-bundle

# Install OVR SDK, compile one of the samples so that the main libs 
#   are precompiled and setup, then empty out the VrSamples folder.
ENV OVR_HOME /opt/ovrsdk
ENV OCULUS_SDK_PATH ${OVR_HOME}
ENV OVR_ROOT ${OVR_HOME}
ENV OVR_PROJ_ROOT ${OVR_HOME}/VrSamples
RUN mkdir -p ${OVR_HOME}
ADD src/ovr_sdk_mobile_1.23.zip ${OVR_HOME}
RUN cd ${OVR_HOME} && \
    unzip ovr_sdk_mobile_1.23.zip && \
    rm ovr_sdk_mobile_1.23.zip

RUN cd ${OVR_HOME} && find -name "*.py" -type f | xargs -r chmod +x
RUN cd ${OVR_HOME} && find -name "*.sh" -type f | xargs -r chmod +x

RUN cd ${OVR_HOME}/VrSamples/VrController/Projects/Android && ./build.py

RUN cd ${OVR_HOME} && rm -rf VrSamples && mkdir VrSamples

ADD src/build.sh /opt
RUN dos2unix /opt/build.sh
RUN chmod +x /opt/build.sh
