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
        
        # Python environment with required packages
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Core dependencies that UTXOracle uses
        ]);

        # UTXOracle package
        utxoracle = pkgs.stdenv.mkDerivation rec {
          pname = "utxoracle";
          version = "9.0";

          src = ./.;

          buildInputs = [ pythonEnv ];

          # No build phase needed - it's a Python script
          dontBuild = true;

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/utxoracle
            
            # Copy the main script (handle both possible locations)
            if [ -f UTXOracle.py ]; then
              cp UTXOracle.py $out/share/utxoracle/
            elif [ -f ./UTXOracle.py ]; then
              cp ./UTXOracle.py $out/share/utxoracle/
            else
              echo "Error: UTXOracle.py not found"
              find . -name "UTXOracle.py" -type f
              exit 1
            fi
            
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
            homepage = "https://github.com/your-repo/utxoracle"; # Update with actual repo
            # Custom license - allows free use for consensus-compatible analysis
            license = {
              spdxId = null;
              fullName = "UTXOracle Custom License v1.0";
              free = true; # Free for consensus-compatible use
              url = "https://github.com/your-repo/utxoracle/blob/main/LICENSE";
            };
            maintainers = [ ];
            platforms = platforms.unix;
          };
        };

        # Development shell with additional tools
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            pythonEnv
            bitcoin
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
            echo "  python3 UTXOracle.py          - Run UTXOracle with default settings"
            echo "  python3 UTXOracle.py -h       - Show help"
            echo "  python3 UTXOracle.py -d YYYY/MM/DD - Analyze specific date"
            echo "  python3 UTXOracle.py -rb      - Use recent 144 blocks"
            echo ""
            echo "Requirements:"
            echo "  - Bitcoin Core node running with server=1 in bitcoin.conf"
            echo "  - bitcoin-cli accessible in PATH"
            echo ""
            echo "Bitcoin version: $(bitcoin-cli --version 2>/dev/null | head -n1 || echo 'Not found - install Bitcoin Core')"
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
