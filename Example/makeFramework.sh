#! /bin/bash

#当前项目所在路径
current_path=`pwd`

#项目
project_name='FMLayoutKit'
#
workspace_name=$project_name

target_name=$project_name

framework_config=Release

#framework输出路径
FRAMEWORK_TARGET_DIR=$current_path/${workspace_name}"Framework"

#临时文件夹路径
BUILD_DIR_TMP=$current_path/'FrameworkTmp'

echo "当前项目所在路径:$current_path"
echo "临时文件夹:$BUILD_DIR_TMP"
echo "framework输出路径:${FRAMEWORK_TARGET_DIR}"

archiveWorkSpace(){
#build之前清理文件
xcodebuild clean -workspace ${workspace_name}.xcworkspace -scheme ${target_name}
#模拟器build
xcodebuild build -workspace ${workspace_name}.xcworkspace -scheme ${target_name} -configuration framework_config -sdk iphonesimulator SYMROOT=${BUILD_DIR_TMP}
#真机build
xcodebuild build -workspace ${workspace_name}.xcworkspace -scheme ${target_name} -configuration framework_config -sdk iphoneos SYMROOT=${BUILD_DIR_TMP}
#OBJROOT=${BUILD_DIR_TMP} SYMROOT=${BUILD_DIR_TMP}

#将模拟器中的framework复制出来
cp -R ${BUILD_DIR_TMP}/${framework_config}-iphonesimulator/${workspace_name}/${workspace_name}.framework ${FRAMEWORK_TARGET_DIR}

#从模拟器中移除arm64架构
lipo ${BUILD_DIR_TMP}/${framework_config}-iphonesimulator/${workspace_name}/${workspace_name}.framework/${workspace_name} -remove arm64 -output ${BUILD_DIR_TMP}/${framework_config}-iphonesimulator/${workspace_name}/${workspace_name}.framework/${workspace_name}
#合并真机和模拟器文件并输出到构建的framework中
lipo -create ${BUILD_DIR_TMP}/${framework_config}-iphonesimulator/${workspace_name}/${workspace_name}.framework/${workspace_name} ${BUILD_DIR_TMP}/${framework_config}-iphoneos/${workspace_name}/${workspace_name}.framework/${workspace_name} -output ${FRAMEWORK_TARGET_DIR}/${workspace_name}.framework/${workspace_name}

#删除无用的三方bundle
find ${FRAMEWORK_TARGET_DIR}/${workspace_name}.framework -maxdepth 1 -name '*.bundle' -not -name "${workspace_name}*.bundle" | xargs rm -rf
#自动打开文件夹
open $FRAMEWORK_TARGET_DIR
}

makeFramework(){
#判断临时文件夹是否存在，存在的话先删除
if [ -d $BUILD_DIR_TMP ];then
rm -rf $BUILD_DIR_TMP
fi
# 判断输出文件夹是否存在，存在的话先删除
if [ -d ${FRAMEWORK_TARGET_DIR} ];then
rm -rf ${FRAMEWORK_TARGET_DIR}
fi

#创建临时文件夹
mkdir -p ${BUILD_DIR_TMP}
#创建输出文件夹
mkdir -p ${FRAMEWORK_TARGET_DIR}

archiveWorkSpace

rm -rf $BUILD_DIR_TMP
}

makeFramework

