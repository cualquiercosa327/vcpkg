include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO openexr/openexr
    REF v2.3.0
    SHA512 268ae64b40d21d662f405fba97c307dad1456b7d996a447aadafd41b640ca736d4851d9544b4741a94e7b7c335fe6e9d3b16180e710671abfc0c8b2740b147b2
    HEAD_REF develop
    PATCHES 001-26c86195935f5365685bfefe046f0ac7e98fa231.patch
            002-c2557b73c97c5dfb9e3eeff6b7622566edcfb54b.patch
            003-ef3ca9e2303fe5f74263e9ac4f7a068baf3ed01f.patch
            004-027a323e375ebe46a6a74863c3c6306dda4427aa.patch
            005-eb2392c88152c05c3b554cc14bc8a1fafb344340.patch
            FindIlmBase.patch
            OpenEXR_CMakeLists.patch
)

# Copy OpenEXR/OpenEXRConfig.h for FindIlmBase.cmake
file(COPY ${CURRENT_PORT_DIR}/OpenEXRConfig.h DESTINATION ${CURRENT_INSTALLED_DIR}/include/OpenEXR)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" OPENEXR_SHARED_LIBS)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" OPENEXR_STATIC_LIBS)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DOPENEXR_BUILD_ILMBASE=OFF
        -DOPENEXR_BUILD_OPENEXR=ON
        -DOPENEXR_BUILD_PYTHON_LIBS=OFF
        -DOPENEXR_BUILD_SHARED=${OPENEXR_SHARED_LIBS}
        -DOPENEXR_BUILD_STATIC=${OPENEXR_STATIC_LIBS}
        -DOPENEXR_BUILD_TESTS=OFF
        -DOPENEXR_BUILD_UTILS=OFF
        -DOPENEXR_BUILD_VIEWERS=OFF
        -DOPENEXR_LOCATION=${CURRENT_INSTALLED_DIR}
    OPTIONS_RELEASE
        -DILMBASE_PACKAGE_PREFIX=${CURRENT_INSTALLED_DIR}
        -DOPENEXR_PACKAGE_PREFIX=${CURRENT_INSTALLED_DIR}
    OPTIONS_DEBUG
        -DILMBASE_PACKAGE_PREFIX=${CURRENT_INSTALLED_DIR}/debug
        -DOPENEXR_PACKAGE_PREFIX=${CURRENT_INSTALLED_DIR}/debug
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/openexr)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/openexr/LICENSE ${CURRENT_PACKAGES_DIR}/share/openexr/copyright)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/FindOpenEXR.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/openexr)
