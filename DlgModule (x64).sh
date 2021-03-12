cd "${0%/*}"

mkdir "DlgModule (x64)"
clang++ "dlgmodule.mm" "setpolicy.mm" "main.cpp" "config.cpp" -o "DlgModule (x64)/dlgmod" -std=c++17 -ObjC++ -framework Cocoa -fPIC -m64
