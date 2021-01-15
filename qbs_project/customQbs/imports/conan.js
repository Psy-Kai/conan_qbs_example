var File = require("qbs.File");
var FileInfo = require("qbs.FileInfo");
var TextFile = require("qbs.TextFile");

function probeBuildInfoJson(generatedFilesPath)
{
    const buildInfoJsonFilePath = FileInfo.joinPaths(generatedFilesPath,
                                                     "conanbuildinfo.json");
    if (!File.exists(buildInfoJsonFilePath))
        throw "No conanbuildinfo.json has beed generated.";

    var jsonFile = new TextFile(buildInfoJsonFilePath, TextFile.ReadOnly);
    const json = JSON.parse(jsonFile.readAll());
    jsonFile.close();
    return json;
}

function extractDependencies(json)
{
    var dependencies = {};
    for (var i = 0; i < json.dependencies.length; ++i) {
        var dep = json.dependencies[i];
        dependencies[dep.name] = dep;
    }
    return dependencies;
}
