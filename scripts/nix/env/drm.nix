{ pkgs ? import <nixpkgs> {} }:

let
  llvmLib = pkgs.llvmPackages_20.libllvm or pkgs.llvmPackages.libllvm;
in
pkgs.mkShell {
  packages = with pkgs; [
    cmake
    ninja
    pkg-config
    gdb
    glfw
    glm
    tinyobjloader
    tinygltf
    nlohmann_json
    openal
    glslang
    shader-slang
    vulkan-headers
    vulkan-loader
    vulkan-tools
    mesa
    libdrm
    zstd
    llvmLib
  ];

  shellHook = ''
    export VULKAN_INCLUDE_DIR="${pkgs.vulkan-headers}/include"
    export VULKAN_LIBRARY="${pkgs.vulkan-loader}/lib/libvulkan.so"
    export CMAKE_PREFIX_PATH="${pkgs.tinygltf}:${pkgs.glfw}:${pkgs.glm}''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
  '';
}

# 构建 Vulkan-Tutorial 的方法，也许可以简化，但是也许不可以:
#
#      cmake -S attachments -B build/attachments-nix -G Ninja \
#        -DCMAKE_BUILD_TYPE=Release \
#        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
#        -DVulkan_INCLUDE_DIR="$VULKAN_INCLUDE_DIR" \
#        -DVulkan_LIBRARY="$VULKAN_LIBRARY" \
#        -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH" &&
#      cmake --build build/attachments-nix -j"$(nproc)"
