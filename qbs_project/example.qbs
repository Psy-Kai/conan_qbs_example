import qbs.Environment
import qbs.File
import qbs.FileInfo
import qbs.Probes
import qbs.TextFile

Project {
    readonly property path conanBuildFolder: undefined
    /* [1] needed until QtCreator can create temporary kits from predefined profiles
       (https://bugreports.qt.io/browse/QTCREATORBUG-23985) */
    readonly property string _conanProfile: {
        if (!profile.startsWith("qtc_"))
            return profile;

        const conanProfile = Environment.getEnv("CONAN_DEFAULT_PROFILE_PATH");
        if (!conanProfile)
            return "default";
        return conanProfile;
    }

    references: [
        "conan.qbs",
        
        "src/src.qbs",
    ]

    qbsSearchPaths: "customQbs"
}
