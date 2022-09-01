#!/bin/bash
cd $OVR_PROJ_ROOT/..
rm -rf $OVR_PROJ_ROOT
mkdir $OVR_PROJ_ROOT
cd $OVR_PROJ_ROOT

cp /proj $OVR_PROJ_ROOT -a
cd $OVR_PROJ_ROOT/proj

find -name "*.mk" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.gradle" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.xml" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.sh" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.sh" -type f | xargs -r chmod +x >/dev/null 2>&1
find -name "*.py" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.py" -type f | xargs -r chmod +x >/dev/null 2>&1
find -name "*.c" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.cpp" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.h" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.hpp" -type f | xargs -r dos2unix >/dev/null 2>&1
find -name "*.java" -type f | xargs -r dos2unix >/dev/null 2>&1

project_name=$(find -name "settings.gradle" -type f | xargs grep -oP 'rootProject.name\s*=\s*\"\K([^\"]+)')
cd ..
mv proj ${project_name} >/dev/null 2>&1
cd ${project_name}
find -name "*.o" -type f | xargs -r rm
find -name "*.so" -type f | xargs -r rm
find -name "*.apk" -type f | xargs -r rm

build_dir=$(find -name "build.py" -type f | xargs dirname)
cd ${build_dir}
cp -n ${OVR_HOME}/*.keystore . || true
cp -n ${OVR_HOME}/fix-gradle.py . || true
chmod +x fix-gradle.py
./fix-gradle.py > build.gradle.new
mv build.gradle build.gradle.old
mv build.gradle.new build.gradle

[ -d "./build" ] && rm -rf ./build
[ -d "./.externalNativeBuild" ] && rm -rf ./.externalNativeBuild
[ -d "./.gradle" ] && rm -rf ./.gradle

./build.py -n
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

find -name "*.apk" -type f | xargs -r -I{} cp -f {} /proj
rc=$?; exit $rc
