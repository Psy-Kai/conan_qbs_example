import qbs
import qbs.FileInfo
import qbs.Probes

Project {
    readonly property path conanfileDir: sourceDirectory

    references: [
        FileInfo.joinPaths(conan.generatedFilesPath, "conan_toolchain.qbs"),
        "profiles.qbs",
        
        "src/src.qbs",
    ]
    
    Probes.ConanfileProbe {
        id: conan
        conanfilePath: FileInfo.joinPaths(project.conanfileDir, "conanfile.py")
        additionalArguments: {
            var args = ["-b=all"]
            if (["mcu/arm"].contains(qbs.profile)) {
                args.push("-pr:h="+qbs.profile)
                args.push("-pr:b=default")
            }
            return args
        }
    }
}
