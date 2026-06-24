# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/ext/yaml-cpp"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-build"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix/tmp"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix/src/yaml-cpp-populate-stamp"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix/src"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix/src/yaml-cpp-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix/src/yaml-cpp-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/yaml-cpp-subbuild/yaml-cpp-populate-prefix/src/yaml-cpp-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
