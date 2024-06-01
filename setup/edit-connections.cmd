@echo off

set path=%path%..\bin;..\..\bin

gConnectionManager.exe dbsetup.exe.config
