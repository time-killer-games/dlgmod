cd "${0%/*}"
clang++ -c -std=c++17 "dlgmod.part1.cpp" "main.cpp" "config.cpp" -fPIC -m64
clang++ -c -ObjC "dlgmod.part2.m" "subclass.m" -fPIC -m64
clang++ "dlgmod.part1.o" "dlgmod.part2.o" "subclass.o" "config.o" "main.o" -o "dlgmod (x64)/dlgmod" -framework Cocoa -fPIC -m64
rm -f "dlgmod.part1.o" "dlgmod.part2.o" "subclass.o" "config.o" "main.o"
chmod 777 "dlgmod (x64)/dlgmod"
