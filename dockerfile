# Oculus Quest Native SDK
# Used for building any of the "VrSamples" based projects.

# USAGE:
#   docker run -it --rm -v %cd%:/proj brainslugs83/ovrsdk /opt/build.sh

# DEBUGGING:
#   docker run -it --rm -v %cd%:/local brainslugs83/ovrsdk bash

FROM thyrlian/android-sdk:latest
LABEL maintainer "brainslugs83@gmail.com"

ENV _JAVA_OPTIONS -XX:+UseContainerSupport

RUN apt-get update -y && \
    apt-get install -y make dos2unix nano file && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

# Downgrade to Gradle 4.x; 5.x has major compatibility issues.
ARG GRADLE_VERSION=4.8
RUN cd /opt && \
    rm -rf gradle && \
    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle*.zip && \
    mv gradle-${GRADLE_VERSION} gradle && \
    rm gradle*.zip

# Install Android SDK
RUN cd ${ANDROID_HOME}/tools/bin && \
    sdkmanager --update && \
    sdkmanager "lldb;3.1" "ndk-bundle" "cmake;3.10.2.4988404" "platform-tools" \
               "platforms;android-21" "platforms;android-22" "platforms;android-23" \
               "platforms;android-24" "platforms;android-25" "platforms;android-26" \
               "platforms;android-27" "platforms;android-28" "platforms;android-29" \
               "build-tools;21.1.2" "build-tools;22.0.1" "build-tools;23.0.3" \
               "build-tools;24.0.3" "build-tools;25.0.3" "build-tools;26.0.3" \
               "build-tools;27.0.3" "build-tools;28.0.3" "build-tools;29.0.1"

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
ADD src/ovr_sdk_mobile_*.zip ${OVR_HOME}
RUN cd ${OVR_HOME} && \
    unzip ovr_sdk_mobile_*.zip && \
    rm ovr_sdk_mobile_*.zip

COPY src/local.properties ${OVR_HOME}
RUN dos2unix ${OVR_HOME}/local.properties

COPY src/gradle-wrapper.properties ${OVR_HOME}/gradle/wrapper
RUN dos2unix ${OVR_HOME}/gradle/wrapper/gradle-wrapper.properties

RUN cd ${OVR_HOME} && find -name "*.py" -type f | xargs -r chmod +x
RUN cd ${OVR_HOME} && find -name "*.sh" -type f | xargs -r chmod +x

RUN cd ${OVR_HOME}/VrSamples/VrController/Projects/Android && ./build.py -n
RUN cd ${OVR_HOME} && find -name "*.keystore" -type f | xargs -r -I{} cp -f {} ${OVR_HOME}
RUN cd ${OVR_HOME} && rm -rf VrSamples && mkdir VrSamples

ADD src/build.sh /opt
RUN dos2unix /opt/build.sh
RUN chmod +x /opt/build.sh
