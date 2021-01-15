import qbs.File
import qbs.Probes
import "conan.js" as ConanHelper

Project {
    id: tandem

    /* input */
    property path buildFolder

//    property stringList additionalArguments: []
    property path conanfilePath
    property path executable
//    property var options
//    property var settings

    property string profileBuild: "default"
    property string profileHost: "default" // `profile.project` would be preferred here but see [1] in example.qbs

    /* output */
    property var dependencies: {
        if (_probeConanfile)
            return conanFileProbe.dependencies;
        return ConanHelper.extractDependencies(json);
    }
    property path generatedFilesPath: {
        if (_probeConanfile)
            return conanFileProbe.generatedFilesPath
        return buildFolder;
    }
    property var json: {
        if (_probeConanfile)
            return conanFileProbe.json;
        return customConanBuildInfoJsonProbe.json;
    }

    /* private */
    readonly property bool _probeConanfile: !(buildFolder && File.exists(buildFolder))

    Probe {
        id: customConanBuildInfoJsonProbe

        condition: !project._probeConanfile
        readonly property bool _probeConanfile: tandem._probeConanfile
        readonly property path _generatedFilesPath: buildFolder
        property var json

        configure: {
            if (!_probeConanfile)
                json = ConanHelper.probeBuildInfoJson(_generatedFilesPath);
        }
    }

    Probes.ConanfileProbe {
        id: conanFileProbe
        condition: tandem._probeConanfile

        readonly property string _buildType: {
            if (qbs.buildVariant === "debug")
                return "Debug";
            if (qbs.buildVariant === "release")
                return "Release";
            if (qbs.buildVariant === "profiling")
                return "RefWithDebInfo";
            throw 'qbs.buildVariant "' + qbs.buildVariant + '" not supported';
        }

        conanfilePath: tandem.conanfilePath
        generators: "qbs"

        Properties {
            condition: !!tandem.executable
            executable: tandem.executable
        }

        additionalArguments: [
            "-pr:b="+tandem.profileBuild,
            "-pr:h="+tandem.profileHost
        ] // .concat(tandem.additionalArguments)
//        settings: {
//            const customSettings = ({build_type: _buildType});
//            console.error(JSON.stringify(customSettings));
//            if (!tandem.settings)
//                return customSettings;

//            var res = {};
//            const tandemSettingsKeys = Object.keys(tandem.settings);
//            for (i in tandemSettingsKeys) {
//                const key = tandemSettingsKeys[i];
//                 res[key] = tandem.settings[key];
//            }
//            const customKeys = Object.keys(customSettings);
//            for (i in customKeys) {
//                const key = customKeys[i];
//                res[key] = settings[key];
//            }

//            console.error(JSON.stringify(res));
//            return res;
//        }
//        options: tandem.options
    }
}
