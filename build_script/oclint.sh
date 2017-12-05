#!/bin/sh

echo 'begin oclint.sh ...'

if which oclint 2>/dev/null; then
    echo 'oclint exist'
else
    echo 'error:please install oclint!!'
    exit -1
fi
if which xcpretty 2>/dev/null; then
    echo 'xcpretty exist'
else
    echo 'error:please install xcpretty!!'
    exit -1
fi

# 程序入口
build_number=$1
if [ -z $build_number ]; then
build_number=0
fi

# 脚本执行所在目录
script_file_dir="`dirname $0`"
script_file_dir_prefix=${root_path:0:1}
if [[ "$script_file_dir_prefix" != "/" ]]; then
script_file_dir="`pwd`/${script_file_dir}"
fi

# 项目根目录
root_path="`dirname $0`/.."
root_path_prefix=${root_path:0:1}
if [[ "$root_path_prefix" != "/" ]]; then
root_path="`pwd`/${root_path}"
fi
src_path="${root_path}/CalendarDemo"
output_path="${root_path}/oclint_output"
script_path="${}/build_script"
xcodebuild="/usr/bin/xcodebuild" 

# 重建output_path目录
if [[ ! -z "$output_path" ]]  && [[ ! -z "$root_path" ]]; then
rm -rf ${output_path}
fi
mkdir -pv ${output_path}

# 进入项目根目录
cd "${src_path}"

# 运行pod
pod install --verbose --no-repo-update

# 使用xcpretty生成compile_commands.json文件
compile_commands_json="${output_path}/compile_commands.json"
"${xcodebuild}" -workspace CalendarDemo.xcworkspace -scheme CalendarDemo -configuration Debug -sdk iphonesimulator COMPILER_INDEX_STORE_ENABLE=NO clean build |tee "${output_path}"/xcodebuild.log |xcpretty --report json-compilation-database --output "${compile_commands_json}"

# 检查 compile_commands.json 是否生成
if [ ! -f "$compile_commands_json" ]; then
    echo 'error：compile_commands.json 文件未成功生成'
    exit -1
fi
echo "compile_commands.json 存在 ${compile_commands_json}"



# 将compile_commands.json转化为oclint.xml -p 引入 compile_commands.json 文件
oclint_xml="${output_path}/oclint.xml"
oclint-json-compilation-database -e Pods -p "${output_path}" -v -- -report-type pmd -o "${oclint_xml}"

# 检查 oclint.xml 是否生成
if [ ! -f "$oclint_xml" ]; then
    echo 'error：oclint.xml 文件未成功生成'
    exit -1
fi

echo "oclint.xml 存在 ${oclint_xml}"
echo 'finish oclint.sh ...'
