{
  description = "UTXOracle - A decentralized Bitcoin USD price oracle using on-chain transaction analysis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        # Python environment with required packages for UTXOracle
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Add any specific Python packages UTXOracle might need
          # requests  # if it needs HTTP requests
          # json is built-in
          # datetime is built-in
        ]);

        # UTXOracle package
        utxoracle = pkgs.stdenv.mkDerivation rec {
          pname = "utxoracle";
          version = "9.0";

          src = pkgs.fetchurl {
            url = "https://utxo.live/oracle/UTXOracle.py";
            sha256 = "9b6d33f9c944dcbe2857847d340a984a0ee9f39a91f5cc2ef17383926a6a02c5";
          };

          buildInputs = [ pythonEnv ];

          # Don't unpack since it's a single file
          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          dontPatch = true;

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/utxoracle
            
            # Copy the downloaded Python file
            cp $src $out/share/utxoracle/UTXOracle.py
            
            # Create wrapper script
            cat > $out/bin/utxoracle << EOF
#!/usr/bin/env bash
exec ${pythonEnv}/bin/python3 $out/share/utxoracle/UTXOracle.py "\$@"
EOF
            chmod +x $out/bin/utxoracle
          '';

          meta = with pkgs.lib; {
            description = "Decentralized Bitcoin USD price oracle using on-chain transaction analysis";
            longDescription = ''
              UTXOracle determines Bitcoin's USD price by analyzing patterns of on-chain transactions
              instead of relying on exchange prices. It connects only to a Bitcoin node and works
              without internet connectivity. Every individual running this code independently
              will produce identical price estimates.
            '';
            homepage = "https://utxo.live/oracle/";
            license = {
              spdxId = null;
              fullName = "UTXOracle Custom License v1.0";
              free = true;
              url = "https://utxo.live/oracle/";
            };
            maintainers = [ ];
            platforms = platforms.unix;
          };
        };

        # Development shell with additional tools
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonEnv
            # Development tools
            python3Packages.black
            python3Packages.flake8
            python3Packages.mypy
          ];

          shellHook = ''
            echo "UTXOracle Development Environment"
            echo "================================"
            echo ""
            echo "Available commands:"
            echo "  utxoracle                     - Run UTXOracle with default settings"
            echo "  utxoracle -h                  - Show help"
            echo "  utxoracle -d YYYY/MM/DD       - Analyze specific date"
            echo "  utxoracle -rb                 - Use recent 144 blocks"
            echo ""
            echo "Requirements:"
            echo "  - Bitcoin Core node running with server=1 in bitcoin.conf"
            echo "  - bitcoin-cli accessible in PATH"
            echo ""
            echo "Bitcoin version: $(bitcoin-cli --version 2>/dev/null | head -n1 || echo 'Not found - install Bitcoin Core')"
            echo ""
            echo "UTXOracle source: https://utxo.live/oracle/UTXOracle.py"
            echo ""
          '';
        };

      in
      {
        packages = {
          default = utxoracle;
          utxoracle = utxoracle;
        };

        apps = {
          default = {
            type = "app";
            program = "${utxoracle}/bin/utxoracle";
          };
          utxoracle = {
            type = "app";
            program = "${utxoracle}/bin/utxoracle";
          };
        };

        devShells.default = devShell;

        # Overlay for adding UTXOracle to nixpkgs
        overlays.default = final: prev: {
          utxoracle = utxoracle;
        };
      });
}
