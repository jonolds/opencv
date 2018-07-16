#!/bin/bash -e
myRepo=$(pwd)
CMAKE_CONFIG_GENERATOR="Visual Studio 15 2017 Win64"
if [  ! -d "$myRepo/opencv"  ]; then
#    echo "clonning opencv"
#    git clone https://github.com/opencv/opencv.git
	echo "pulling opencv"
	git pull https://github.com/jonolds/opencv.git
    mkdir Build
    mkdir Build/opencv
    mkdir Install
    mkdir Install/opencv
else
    cd opencv
    git pull --rebase
    cd ..
fi
if [  ! -d "$myRepo/opencv_contrib"  ]; then
#    echo "clonning opencv_contrib"
#    git clone https://github.com/opencv/opencv_contrib.git
	echo "pulling opencv_contrib"
	git pull https://github.com/jonolds/opencv_contrib.git
#    mkdir Build
    mkdir Build/opencv_contrib
else
    cd opencv_contrib
    git pull --rebase
    cd ..
fi
RepoSource=opencv
pushd Build/$RepoSource
CMAKE_OPTIONS='-DBUILD_PERF_TESTS:BOOL=OFF -DBUILD_JAVA:BOOL=OFF -DBUILD_opencv_java:BOOL=OFF -D BUILD_opencv_java_bindings_generator:BOOL=OFF -DBUILD_opencv_python2:BOOL=OFF -DBUILD_opencv_python_bindings_generator:BOOL=OFF -DBUILD_TESTS:BOOL=OFF -DBUILD_DOCS:BOOL=OFF  -DWITH_CUDA:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF -DINSTALL_CREATE_DISTRIB=ON'
cmake -G"$CMAKE_CONFIG_GENERATOR" $CMAKE_OPTIONS -DOPENCV_EXTRA_MODULES_PATH="$myRepo"/opencv_contrib/modules -DCMAKE_INSTALL_PREFIX="$myRepo"/install/"$RepoSource" "$myRepo/$RepoSource"
echo "************************* $Source_DIR -->debug"
cmake --build .  --config debug
echo "************************* $Source_DIR -->release"
cmake --build .  --config release
cmake --build .  --target install --config release
cmake --build .  --target install --config debug
popd