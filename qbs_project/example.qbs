import qbs.Environment
import qbs.File
import qbs.FileInfo
import qbs.Probes
import qbs.TextFile

Project {
    readonly property path conanBuildFolder: undefined
    readonly property bool _probeConanfile: !(conanBuildFolder && File.exists(conanBuildFolder))
    readonly property path _conanGeneratedFilesPath: {
        if (_probeConanfile)
            return conan.generatedFilesPath;
        return conanBuildFolder;
    }
    readonly property var _conanBuildInfoJson: {
        if (_probeConanfile)
            return conan.json;
        return customConanBuildInfoJsonProbe.json;
    }
    /* [1] needed until QtCreator can create temporary kits from predefined profiles
       (https://bugreports.qt.io/browse/QTCREATORBUG-23985) */
    readonly property string _conanProfile: {
        const profile = Environment.getEnv("CONAN_DEFAULT_PROFILE_PATH");
        if (!profile)
            return "default";
        return profile;
    }

    references: [
        FileInfo.joinPaths(_conanGeneratedFilesPath, "conan_toolchain.qbs"),
        "profiles.qbs",
        
        "src/src.qbs",
        FileInfo.joinPaths(_conanGeneratedFilesPath, "conanbuildinfo.qbs")
    ]
    
    Probe {
        id: customConanBuildInfoJsonProbe
        condition: !project._probeConanfile
        readonly property path conanGeneratedFilesPath: _conanGeneratedFilesPath
        property var json

        configure: {
            const buildInfoJsonFilePath = FileInfo.joinPaths(conanGeneratedFilesPath,
                                                             "conanbuildinfo.json");
            if (!File.exists(buildInfoJsonFilePath))
                throw "No conanbuildinfo.json has beed generated.";

            var jsonFile = new TextFile(buildInfoJsonFilePath, TextFile.ReadOnly);
            json = JSON.parse(jsonFile.readAll());
            jsonFile.close();
        }
    }

    Probes.ConanfileProbe {
        id: conan
        condition: project._probeConanfile

        readonly property string _buildType: {
            if (qbs.buildVariant === "debug")
                return "Debug";
            if (qbs.buildVariant === "release")
                return "Release";
            if (qbs.buildVariant === "profiling")
                return "RefWithDebInfo";
            throw 'qbs.buildVariant "' + qbs.buildVariant + '" not supported';
        }

        conanfilePath: FileInfo.joinPaths(sourceDirectory, "conanfile.py")
        generators: "qbs"
        additionalArguments: {
            var args = ["-b=all"];
            args.push("-pr:b=default");
            /* see [1] above */
            args.push("-pr:h="+_conanProfile);
            /* preferred version */
            // args.push("-pr:h="+project.profile);
            return args;
        }
        settings: ({build_type: _buildType})
    }
}
