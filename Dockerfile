FROM debian:stretch

ENV FLUTTER_HOME="/usr/lib/flutter"
ENV ANDROID_HOME="/usr/lib/android-sdk"
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip"
ENV ANDROID_PLATFORM_TOOLS_URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"

RUN apt-get update && apt-get upgrade
RUN apt-get install git unzip ca-certificates curl zip default-jdk-headless -y --no-install-recommends \
    && apt-get clean -y \
    && apt-get autoremove -y

# Latest android sdk
RUN curl ${ANDROID_SDK_URL} -L --output tools.zip && unzip tools.zip -d ${ANDROID_HOME}
RUN curl ${ANDROID_PLATFORM_TOOLS_URL} -L --output platform-tools.zip && ls && unzip platform-tools -d ${ANDROID_HOME}

# Stable flutter sdk
RUN git clone -b stable https://github.com/flutter/flutter.git ${FLUTTER_HOME}

ENV PATH="${FLUTTER_HOME}/bin:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform_tools:${PATH}"

# Accept all licenses
RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses
RUN flutter config --no-analytics

# Fetch dependencies
RUN flutter precache

ENTRYPOINT ["flutter"]
