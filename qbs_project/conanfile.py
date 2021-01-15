from conans import ConanFile, tools
from conan.tools.qbs import QbsToolchain
from conan.tools.qbs import Qbs


class ConanQbsExample(ConanFile):
    name = "QbsExample"
    version = "1.0.0"
    exports_sources = ["*.qbs", "*.cpp"]
    settings = [
        "os",
        "compiler"
    ]
    generators = ["qbs", "json"]

    def generate(self):
        # properly merge environment variables
        env = {}
        for dep in self.deps_env_info.deps:
            for var, value in self.deps_env_info[dep].vars.items():
                if not value:
                    continue
                if var in env:
                    if type(env[var]) is list:
                        env[var].extend(value)
                    else:
                        env[var] += ' %s' % value
                else:
                    env[var] = value

        with tools.environment_append(env):
            toolchain = QbsToolchain(self)
            toolchain.generate()

    def build(self):
        qbs = Qbs(self, 'example.qbs')

        # we may have set additional properties in qbs so compile for proper Qbs profile
        if self.settings.os == "Mcu":
            qbs.use_toolchain_profile = "mcu/arm"
        else:
            qbs.use_toolchain_profile = "default"

        qbs.add_configuration("default", {
            'projects.example.conanBuildFolder': self.build_folder
        })
        qbs.build()
        if tools.get_env("CONAN_RUN_TESTS", False):
            qbs.build(products=["autotest-runner"])
