from conans import ConanFile


class ConanArmMcuFlags(ConanFile):
    name = "arm.toolchain.flags"
    version = "1.0.0"

    def package_info(self):
        self.env_info.LDFLAGS = "-Wl,--defsym=_min_heap_size=0x800 -specs=nosys.specs"
        self.env_info.CFLAGS = "-march=armv7e-m -mtune=cortex-m4"
        self.env_info.CXXFLAGS = "%s -fno-rtti -fno-exceptions" % self.env_info.CFLAGS
