#!/bin/sh
set -e

# Determine target ABI
if [ -n "$1" ]; then
    ABI=$1
elif [ -z "$ABI" ]; then
    uname_arch=`adb shell uname -m`

    case $uname_arch in
        x86_64) ABI=x86_64 ;;
        aarch64) ABI=arm64-v8a ;;
        *) echo "Architecture $uname_arch is not supported."
           exit 1 ;;
    esac
fi
echo "Determined target $ABI."

# Various dirs
sbcl_dir=build/external/sbcl-android-pptl-build-$ABI
pack_name=sbcl-android-pptl-$ABI
jni_libs=prebuilt/libs/$ABI
adb_sbcl_dir=/data/local/tmp/sbcl

# Ensure build directory exists
mkdir -p build/external

# Clean (adb)
echo "Deleting $adb_sbcl_dir on the target device."
adb shell rm -rf "$adb_sbcl_dir"

# Use prebuilt SBCL if it exists and SBCL_REBUILD is not set
if [ -z "$SBCL_REBUILD" ]; then
    if [ -f prebuilt/sbcl/"$pack_name".zip ] || [ -d build/external/"$pack_name" ]; then
        # Unzip prebuilt sbcl if needed
        if [ ! -d build/external/"$pack_name" ]; then
            unzip prebuilt/sbcl/"$pack_name".zip -d build/external
        fi

        # Copy files to android
        adb push build/external/"$pack_name"/ "$adb_sbcl_dir"/

        # Copy libsbcl.so to prebuilt/libs folder, as well as libraries from android-libs
        echo "Copying build/external/$pack_name/src/runtime/libsbcl.so to $jni_libs."
        cp build/external/"$pack_name"/src/runtime/libsbcl.so "$jni_libs"
        if [ -d build/external/"$pack_name"/output/android-libs ]; then
            echo "Copying build/external/$pack_name/output/android-libs/lib*.so to $jni_libs."
            cp build/external/"$pack_name"/output/android-libs/lib*.so "$jni_libs"
        fi

        # Exit early
        exit 0
    fi
fi

# Clean or clone (repo)
if [ -d "$sbcl_dir" ];
then
    echo "Cleaning $sbcl_dir."

    ( cd "$sbcl_dir";
      git checkout sbcl-android-upd-pptl-2;
      ./clean.sh;
      if [ -d android-libs ]; then rm -r android-libs; fi
      if [ -d "$pack_name" ]; then rm -r "$pack_name"; fi
      if [ -f "$pack_name.zip" ]; then rm "$pack_name.zip"; fi )
else
    echo "Cloning SBCL into $sbcl_dir."
    git clone https://github.com/Gleefre/sbcl.git -b sbcl-android-upd-pptl-2 "$sbcl_dir"
fi

# Setup android-libs
echo "Creating $sbcl_dir/android-libs."
cp -r prebuilt/sbcl-android-libs "$sbcl_dir"/android-libs

# Build
echo "Building SBCL."
( cd "$sbcl_dir";
  echo '"2.5.6-android"' > version.lisp-expr;
  ./make-android.sh --fancy --android-target-location="$adb_sbcl_dir" )

# Pack
echo "Packing SBCL into $pack_name."
cp build-scripts/sbcl-android-pack.sh "$sbcl_dir"
( cd "$sbcl_dir";
  ./sbcl-android-pack.sh "$pack_name";
  zip -r "$pack_name" "$pack_name"; )

# Move pack folder to build/external
if [ -d build/external/"$pack_name" ]; then
    rm -r build/external/"$pack_name"
fi
mv "$sbcl_dir"/"$pack_name" build/external/"$pack_name"

# Move packed zip to prebuilt/sbcl
echo "Moving $sbcl_dir/$pack_name to prebuilt/sbcl."
mv "$sbcl_dir"/"$pack_name".zip prebuilt/sbcl

# Copy libsbcl.so to prebuilt/libs folder, as well as libraries from android-libs
echo "Copying $sbcl_dir/src/runtime/libsbcl.so to $jni_libs."
cp "$sbcl_dir"/src/runtime/libsbcl.so "$jni_libs"
if [ -d "$sbcl_dir"/output/android-libs ]; then
    echo "Copying $sbcl_dir/output/android-libs/lib*.so to $jni_libs."
    cp "$sbcl_dir"/output/android-libs/lib*.so "$jni_libs"
fi
