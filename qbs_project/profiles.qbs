Project {
    /* let Qbs profiles have the same name as the supported conan profiles */

    Profile {
        name: "default"
        baseProfile: "conan_toolchain_profile"
    }

    Profile {
        name: "mcu/arm"
        baseProfile: "conan_toolchain_profile"
        /* may have additional properties set */
    }
}
