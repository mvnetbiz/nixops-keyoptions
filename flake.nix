{
  description = "nixops python type bug";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    inherit (nixpkgs) lib;
  in
  {
    nixopsConfigurations.default = {
      inherit nixpkgs;
      network.description = "test";
      network.storage.legacy = {
        databasefile = "test.nixops";
      };
      machine = {
        system.stateVersion = "23.11";
        deployment.targetEnv = "libvirtd";
        deployment.keys.test = {
          keyCommand = [ "dd" "of=/dev/urandom" "bs=1" "count=10" ];
          user = "root";
        };
        #deployment.libvirtd.imageDir = "/var/lib/libvirt/images";
      };
    };

    defaultPackage.x86_64-linux =
      with pkgs;
      (buildEnv {
        name = "test";
        paths = [
          #pkgs.nixVersions.nix_2_13
          #apacheHttpd
          #awscli2
          #jq
          nixops_unstable
          #openssl
          #sqlite
        ];
      });
  };
}
