from conans import ConanFile


class ConanArmNoneEabi(ConanFile):
    name = "arm.toolchain.compiler"
    version = "1.0.0"

    def package_info(self):
        is_example = True
        package_folder = "/usr/bin" if is_example else self.package_folder
        self.env_info.CC = "%s/arm-none-eabi-gcc" % package_folder
        self.env_info.CXX = "%s/arm-none-eabi-g++" % package_folder
