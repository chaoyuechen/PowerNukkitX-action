FROM openjdk:17.0.2-slim AS run

COPY ./powernukkitx-full.jar /app/powernukkitx.jar

# Create minecraft user
RUN useradd --user-group \
            --no-create-home \
            --home-dir /data \
            --shell /usr/sbin/nologin \
            minecraft

# Ports
EXPOSE 19132/udp

# Make app owned by minecraft user
RUN mkdir /data && chown -R minecraft:minecraft /app /data

# Volumes
VOLUME /data /home/minecraft

# User and group to run as
USER minecraft:minecraft

# Set runtime workdir
WORKDIR /data

ENV JVM_OPTS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
ENV MEM="-Xms1G -Xmx1G"
# Run app
CMD [ "java","${JVM_OPTS} ${MEM}", "-jar", "/app/powernukkitx.jar" ]
