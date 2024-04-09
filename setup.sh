git clone git@github.com:Juiced-Devs/kalyx
git clone git@github.com:kyleraykbs/kyler
git add -A
cd kalyx
git add -A
cd ..
cd kyler
git add -A
cd ..
nix flake lock --update-input kalyx
nix flake lock --update-input kyler