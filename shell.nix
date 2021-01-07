{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { stdenv, makeWrapper, lib, gnused, jq, sxiv }:
      stdenv.mkDerivation {
        pname = "rofi-menu";
        version = "0.1.0.0";
        src = ./.;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          install -D rofi-menu-history $out/bin/rofi-menu-history
        '';

        postFixup = ''
          wrapProgram $out/bin/rofi-menu-history --prefix PATH : ${lib.makeBinPath [ gnused jq sxiv ]}
        '';

        meta = {
          homepage = "https://github.com/emmanuelrosa/rofi-menu";
          description = "Various rofi menus (aka. modi)";
          license = stdenv.lib.licenses.mit;
        };
      };
in
  with pkgs; pkgs.callPackage f { inherit makeWrapper; }
