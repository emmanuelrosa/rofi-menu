{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { stdenv, makeWrapper, lib, gnused, jq, sxiv, fd, file, xdg-utils }:
      stdenv.mkDerivation {
        pname = "rofi-menu";
        version = "0.6.0";
        src = ./.;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          install -D rofi-menu-history $out/bin/rofi-menu-history
          install -D rofi-menu-shutdown $out/bin/rofi-menu-shutdown
          install -D rofi-menu-open $out/bin/rofi-menu-open
        '';

        postFixup = ''
          wrapProgram $out/bin/rofi-menu-history --prefix PATH : ${lib.makeBinPath [ gnused jq sxiv ]}
          wrapProgram $out/bin/rofi-menu-open --prefix PATH : ${lib.makeBinPath [ fd sxiv file xdg-utils ]}
        '';

        meta = {
          homepage = "https://github.com/emmanuelrosa/rofi-menu";
          description = "Various rofi menus (aka. modi)";
          license = pkgs.lib.licenses.mit;
        };
      };
in
  with pkgs; pkgs.callPackage f { inherit makeWrapper; 
                                }
