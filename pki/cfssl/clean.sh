#!/bin/bash

set -euo pipefail

# Get the directory of the current script
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

rm -f ca-key.pem ca.csr ca.pem server-key.pem server.csr server.pem
