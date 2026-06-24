# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/ext/spdlog"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-build"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix/tmp"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix/src/spdlog-populate-stamp"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix/src"
  "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix/src/spdlog-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix/src/spdlog-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/RAID2/COURSE/2026_Spring/es26mcs/es26mcs068/ramulator2/build/_deps/spdlog-subbuild/spdlog-populate-prefix/src/spdlog-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
