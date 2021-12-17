# requires powershell3 or later

cd $PSScriptRoot

Remove-Item build -Recurse -ErrorAction Ignore

mkdir -p build
cd build >$null 2>&1
# Specify the x64 architecture, otherwise can't find cuda
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release --target gpu-miner
cd ..
