import qbs.Environment
import qbs.File
import qbs.FileInfo
import qbs.Probes
import qbs.TextFile

Project {
    readonly property path conanBuildFolder: undefined
    readonly property path _conanGeneratedFilesPath: {
        if (conanBuildFolder)
            return conanBuildFolder;
        return conanFileProbe.generatedFilesPath;
    }
    readonly property string _conanProfile: "conan_toolchain_profile"

    references: [
        FileInfo.joinPaths(_conanGeneratedFilesPath, "conan_toolchain.qbs"),

        "src/src.qbs",
        FileInfo.joinPaths(_conanGeneratedFilesPath, "conanbuildinfo.qbs")
    ]

    qbsSearchPaths: "customQbs"

    Probes.ConanfileProbe {
        id: conanFileProbe
        condition: !project.conanBuildFolder

        readonly property string _buildType: {
            if (qbs.buildVariant === "debug")
                return "Debug";
            if (qbs.buildVariant === "release")
                return "Release";
            if (qbs.buildVariant === "profiling")
                return "RefWithDebInfo";
            throw 'qbs.buildVariant "' + qbs.buildVariant + '" not supported';
        }

        /* [1] needed until QtCreator can create temporary kits from predefined profiles
        (https://bugreports.qt.io/browse/QTCREATORBUG-23985) */
        readonly property string _profile: {
            const profile = Environment.getEnv("CONAN_DEFAULT_PROFILE_PATH");
            if (!profile)
                return "default";
            return profile;
        }

        conanfilePath: FileInfo.joinPaths(project.sourceDirectory, "conanfile.py")
        generators: "qbs"

        additionalArguments: [
            "-pr:b=default",
            "-pr:h="+_profile
        ]
    }
}
