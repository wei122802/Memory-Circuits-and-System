# ======================================================
# MCS TA Shared Toolset (GCC 13.2.0 & CMake 3.28.1)
# ======================================================
setenv TA_SHARE /RAID2/COURSE/2026_Spring/es26mcs/es26mcsTA05/share/local_tools

setenv PATH ${TA_SHARE}/cmake-3.28.1/bin:$PATH
setenv PATH ${TA_SHARE}/gcc-13.2.0/bin:$PATH

if ( $?LD_LIBRARY_PATH ) then
    setenv LD_LIBRARY_PATH ${TA_SHARE}/gcc-13.2.0/lib64:$LD_LIBRARY_PATH
else
    setenv LD_LIBRARY_PATH ${TA_SHARE}/gcc-13.2.0/lib64
endif

setenv CC ${TA_SHARE}/gcc-13.2.0/bin/gcc
setenv CXX ${TA_SHARE}/gcc-13.2.0/bin/g++

if ($?prompt) then
    echo ""
    echo "\033[31mIn MCS Ramulator HW environment, do \033[5mnot\033[25m type the keywords yes', 'layout' or 'coding'\033[0m"
    echo ""
    set prompt="`date '+%H:%M'` %n@%m[%~]% "
endif