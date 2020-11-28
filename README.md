# conan_qbs_example
Example project showing the usage of conans Qbs build helper and QbsToolchain generator

Requirements
--
*  Linux
*  `arm-none-eabi-gcc` installed at `/usr/bin`
*  default conan profile (can be created via `conan profile new --detect default`)
*  Qbs in PATH
*  conan in PATH

To setup this example you need to execute the following steps:
-  add `Mcu` to conans `settings.yml` as `os`
-  copy profile `mcu/arm` to `.conan/profiles
-  export the example build requirements via
`conan export toolchain_definitions/conanfile_none_eabi_arm.py` and
`conan export toolchain_definitions/conanfile_generic_mcu_flags.py`

Now compiling and package creation can start :D  
Just call `qbs -f qbs_project/example.qbs` or `conan create qbs_project` 
for native compilation and
`qbs -f qbs_project/example.qbs profile:mcu/arm` or 
`conan create qbs_project -pr:b default -pr:h mcu/arm` to cross compile for arm.
