#!/bin/bash -ex
wget -r -l1 -nd -np -A.en-US.android-arm.tar.gz,.en-US.android-arm.crashreporter-symbols.zip --user=${B2G_BUILD_USERNAME} --password=${B2G_BUILD_PASSWORD} $1
FILES="gaia.zip sources.xml $2.zip"
for FILE in ${FILES}; do
  wget --user=${B2G_BUILD_USERNAME} --password=${B2G_BUILD_PASSWORD} $1/${FILE}
done
mv b2g-*.en-US.android-arm.tar.gz b2g.en-US.android-arm.tar.gz
mv b2g-*.en-US.android-arm.crashreporter-symbols.zip b2g.en-US.android-arm.crashreporter-symbols.zip
mv $2.zip device.zip
