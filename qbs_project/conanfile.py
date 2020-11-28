from conans import ConanFile, tools
from conans.client.toolchain.qbs.generic import QbsGenericToolchain
from conans.client.build.qbs import Qbs


class ConanQbsExample(ConanFile):
    name = "QbsExample"
    version = "1.0.0"
    exports_sources = ["*.qbs", "*.cpp"]
    settings = [
        "os",
        "compiler"
    ]

    def toolchain(self):
        with tools.environment_append(self.deps_env_info.vars):
            qbs_toolchain = QbsGenericToolchain(self)
            qbs_toolchain.generate()

    def build(self):
        qbs = Qbs(self, 'example.qbs')
        qbs.add_configuration("default", {
            'projects.example.conanfileDir': self.recipe_folder
        })
        qbs.build()
