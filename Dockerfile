FROM debian:stretch

ENV FLUTTER_HOME="/usr/lib/flutter"
ENV ANDROID_HOME="/usr/lib/android-sdk"
ENV ANDROID_SDK_ROOT="/usr/lib/android-sdk"
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip"
ENV ANDROID_PLATFORM_TOOLS="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"

########################### Fetch dependencies ###########################
# ========================================================================
RUN apt-get update && apt-get upgrade \
    && apt-get install git unzip bash curl wget xz-utils zip default-jdk-headless -y --no-install-recommends \
    && apt-get autoremove -y

# Android sdk
RUN wget -O tools.zip ${ANDROID_SDK_URL}
RUN unzip -u tools.zip -d ${ANDROID_HOME}
RUN wget -O platform-tools.zip ${ANDROID_PLATFORM_TOOLS}
RUN unzip platform-tools.zip -d ${ANDROID_HOME}

# Stable flutter sdk
RUN git clone -b stable https://github.com/flutter/flutter.git ${FLUTTER_HOME}
# ========================================================================

########################### Install & configure ###########################
# ========================================================================
ENV PATH="${FLUTTER_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform_tools:${PATH}"

# Accept all licenses
RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses
RUN flutter config --no-analytics

# Fetch dependencies & upgrade
RUN flutter --version
RUN flutter precache
# ========================================================================

ENTRYPOINT ["flutter"]
