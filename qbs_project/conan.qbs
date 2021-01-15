import qbs.Environment
import qbs.FileInfo
import ConanTandemProbe

Project {
    references: [
        FileInfo.joinPaths(conan.generatedFilesPath, "conan_toolchain.qbs"),
        "profiles.qbs",
        FileInfo.joinPaths(conan.generatedFilesPath, "conanbuildinfo.qbs"),
    ]

    ConanTandemProbe {
        id: conan
        buildFolder: conanBuildFolder
        conanfilePath: FileInfo.joinPaths(sourceDirectory, "conanfile.py")
        profileHost: _conanProfile
    }
}
