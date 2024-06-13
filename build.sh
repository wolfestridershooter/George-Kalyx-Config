operation="switch"
systemname="${HOSTNAME:-default_system}"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --operation|-o)
            if [[ -n $2 && $2 != -* ]]; then
                operation="$2"; shift
            else
                echo "Error: --operation requires a non-empty option argument."
                exit 1
            fi
            ;;
        --systemname|-s)
            if [[ -n $2 && $2 != -* ]]; then
                systemname="$2"; shift
            else
                echo "Error: --systemname requires a non-empty option argument."
                exit 1
            fi
            ;;
        *)
            echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Operation: $operation"
echo "System Name: $systemname"

git add -A
cd kalyx
git add -A
cd ..
cd kyler
git add -A
cd ..
nix flake lock --update-input kalyx
nix flake lock --update-input kyler
sudo nixos-rebuild $operation --flake ./#$systemname
