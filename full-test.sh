current_dir=$(basename "$PWD")

if [[ "$current_dir" != "george-kalyx-config" && "$current_dir" != "George-Kalyx-Config" ]]; then
  git clone https://github.com/wolfestridershooter/george-kalyx-config
  cd george-kalyx-config
fi

git clone https://github.com/kyleraykbs/kyler
git clone https://github.com/Juiced-Devs/kalyx
nix flake update --extra-experimental-features "nix-command flakes"
./build.sh -o build -s citadel-core
