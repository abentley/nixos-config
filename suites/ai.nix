{
  pkgs,
  unstable ? null,
  ...
}:

let
  basePkgs =
    if unstable == null then
      pkgs
    else if unstable ? ollama then
      unstable
    else
      import unstable {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
        };
      };

  ollamaVersion = "0.33.2";
  llamaVersion = "b10630";

  llamaCppSrc = basePkgs.fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = llamaVersion;
    hash = "sha256-h7D/vn/tu2DyzvqhJauWJ+a2TMcjnW527Gv28YrB80I=";
  };

  ollamaSrc = basePkgs.fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${ollamaVersion}";
    hash = "sha256-jzhzMkEC/X4AyLOcBB8lAPcef9B+pmM+WhvDgsd6D2E=";
  };

  overrideOllama =
    pkg:
    pkg.overrideAttrs (oldAttrs: {
      version = ollamaVersion;
      src = ollamaSrc;
      vendorHash = "sha256-HMwoaFBMbpoy8f0I+O+i7kIa9BslLu3FcVWeaIOkpvs=";
      postPatch = ''
        substituteInPlace version/version.go \
          --replace-fail 0.0.0 "${ollamaVersion}"
        rm -f cmd/launch/*_test.go
        rm -rf app
        if [[ "${llamaVersion}" != $(cat LLAMA_CPP_VERSION) ]]; then
          echo "llama-cpp version mismatch, expected ${llamaVersion}, but found $(cat LLAMA_CPP_VERSION)"
          exit 1
        fi
        cp -r ${llamaCppSrc} $TMPDIR/llama-cpp-src
        chmod -R +w $TMPDIR/llama-cpp-src
        ( cd $TMPDIR/llama-cpp-src && \
          cmake -DPATCH_DIR=$NIX_BUILD_TOP/source/llama/compat \
            -DPATCH_LABEL=llama/compat \
            -P $NIX_BUILD_TOP/source/cmake/apply-git-patches.cmake )
      '';
      ldflags = [
        "-X=github.com/ollama/ollama/version.Version=${ollamaVersion}"
        "-X=github.com/ollama/ollama/server.mode=release"
      ];
    });

  aiPkgs = basePkgs // {
    ollama = overrideOllama basePkgs.ollama;
    ollama-vulkan = overrideOllama basePkgs.ollama-vulkan;
    ollama-cuda = overrideOllama basePkgs.ollama-cuda;
  };
in
{
  nixpkgs.config.allowUnfree = true;
  # NVidia 1070 GTX support
  # nixpkgs.config.cudaCapabilities = [ "6.1" ];
  services.ollama = {
    enable = true;
    # package = aiPkgs.ollama-cuda;
    package = aiPkgs.ollama-vulkan;
    # Pre-fetch models on service start (optional)
    loadModels = [
      "llama3.2:3b"
      "qwen2.5-coder:7b"
    ];
    # For network access:
    # host = "0.0.0.0";
    # port = 11434;
    # openFirewall = true;
  };

  services.open-webui = {
    enable = true;
    package = aiPkgs.open-webui;
    host = "0.0.0.0";
    port = 8080;
    openFirewall = true;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  environment.variables = {
    OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
  };
  # Expose client tools in system profile
  environment.systemPackages = [
    aiPkgs.ollama
    aiPkgs.aider-chat
  ];
}
