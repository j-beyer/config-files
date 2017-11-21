{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "gradle-wrapper-env";
  targetPkgs = pkgs: (with pkgs; [
    gcc
  ]);
  profile = with pkgs; ''
    export JAVA_HOME=${jdk.home}
    export LD_LIBRARY_PATH=${gcc}/lib/:$LD_LIBRARY_PATH
  '';
  runScript = "fish";
}).env
