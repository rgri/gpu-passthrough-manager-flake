{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    git = {
      url = "github:uwzis/gpu-passthrough-manager";
      flake = false;
    };
  };
  outputs = { self, ... }@inp:
    let
      pkgs = inp.nixpkgs.legacyPackages.x86_64-linux;
      buildStuff = with pkgs; [
        pkg-config
        polkit
        jsoncpp
        python310
        gtk3.dev
        gtk4.dev
      ];
    in with pkgs; {
      GPUPM = stdenv.mkDerivation rec {
        name = "GPUPM";
        version = "1.0";
        src = inp.git;
        nativeBuildInputs = buildStuff;
        buildInputs = buildStuff;
        installPhase = ''
          mkdir -p $out/bin
          cp GPUPM $out/bin
        '';
      };
    };
}
