Project {
    CppApplication {
        files: "main.cpp"

        /* since we use the same names for Qbs and conan profiles this works;
           only needed until [1] (see examples.qbs) is implemented */
        qbs.profile: _conanProfile
    }
}
