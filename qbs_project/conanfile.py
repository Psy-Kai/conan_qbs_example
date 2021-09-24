from conans import ConanFile, tools
from conan.tools.qbs import QbsProfile
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
        profile = QbsProfile(self)
        profile.generate()

    def build(self):
        qbs = Qbs(self, 'example.qbs')

        qbs.add_configuration("default", {
            'projects.example.conanBuildFolder': self.build_folder
        })
        qbs.build()
