# Define the packages to update
packages=("land-verktoy" "flagg-ikoner" "landvelger")  # <-- Update the rest as needed

CUSTOM_COMMIT_MESSAGE=$1

if [ -z "$1" ]; then
   echo "Usage: bumpPackage"
   exit 1
fi

compute_new_version() {
  local current_version="$1"
  local bump_type="$2"
  local wip_flag="$3"
  local current_version_without_wip="${current_version%-wip*}"
  local major minor patch
  local current_wip=0
  local wip_section wip_ending
  local new_major new_minor new_patch
  local new_version

  IFS='.' read -r major minor patch <<< "$current_version_without_wip"

  if [[ "$current_version" == *"-wip"* ]]; then
    wip_section="${current_version##*-}"
    wip_ending="${wip_section#wip}"
    current_wip="${wip_ending:-1}"
  fi

  if [ "$bump_type" = "major" ]; then
    if [ "$wip_flag" = "wip" ]; then
      new_major=$((major + 1))
      new_minor=0
      new_patch=0
      new_version="$new_major.$new_minor.$new_patch-wip1"
    else
      new_major=$((major + 1))
      new_minor=0
      new_patch=0
      new_version="$new_major.$new_minor.$new_patch"
    fi
  elif [ "$bump_type" = "minor" ]; then
    if [ "$wip_flag" = "wip" ]; then
      new_minor=$((minor + 1))
      new_patch=0
      new_version="$major.$new_minor.$new_patch-wip1"
    else
      new_minor=$((minor + 1))
      new_patch=0
      new_version="$major.$new_minor.$new_patch"
    fi
  elif [ "$bump_type" = "patch" ]; then
    if [ "$wip_flag" = "wip" ]; then
      new_patch=$((patch + 1))
      new_version="$major.$minor.$new_patch-wip1"
    else
      new_patch=$((patch + 1))
      new_version="$major.$minor.$new_patch"
    fi
  elif [ "$bump_type" = "wip" ]; then
    if [[ "$current_version" == *"-wip"* ]]; then
      new_version="${current_version_without_wip}-wip$((current_wip + 1))"
    else
      new_patch=$((patch + 1))
      new_version="$major.$minor.$new_patch-wip1"
    fi
  else
    if [[ "$current_version" == *"-wip"* ]]; then
      new_version="$current_version_without_wip"
    else
      new_patch=$((patch + 1))
      new_version="$major.$minor.$new_patch"
    fi
  fi

  printf '%s\n' "$new_version"
}

for package in "${packages[@]}"; do

  echo "Updating $package..."
  cd "$package" || continue

  if ! command -v jq >/dev/null 2>&1; then
      echo "Error: jq is required but not installed."
      exit 1
  fi

  if [ ! -f package.json ]; then
      echo "No package.json found in $package, skipping."
      cd ..
      continue
  fi

  git pull

  if [ "$package" == "flagg-ikoner" ] || [ "$package" == "landvelger" ]; then
    current_land_verktoy_peer_dep=$(jq -r '.peerDependencies["@navikt/land-verktoy"]' package.json)

    current_land_verktoy_version="${current_land_verktoy_peer_dep%%||*}"
    current_land_verktoy_version="$(echo "$current_land_verktoy_version" | xargs)"

    new_version=$(compute_new_version "$current_land_verktoy_version" "$2" "$3")

    land_verktoy_peer_dep_range="${current_land_verktoy_peer_dep#*||}"
    land_verktoy_peer_dep_range="${land_verktoy_peer_dep_range:+||$land_verktoy_peer_dep_range}"

    new_land_verktoy_peer_dep="${new_version}${land_verktoy_peer_dep_range}"

    echo "Bumping land-verktoy from $current_land_verktoy_peer_dep to $new_land_verktoy_peer_dep..."

    jq --arg newver "$new_land_verktoy_peer_dep" \
      '.peerDependencies["@navikt/land-verktoy"] = $newver' \
      package.json > tmp.json && mv tmp.json package.json

  fi

    if [ "$package" == "landvelger" ]; then
      current_flagg_ikoner_peer_dep=$(jq -r '.peerDependencies["@navikt/flagg-ikoner"]' package.json)

      current_flagg_ikoner_version="${current_flagg_ikoner_peer_dep%%||*}"
      current_flagg_ikoner_version="$(echo "$current_flagg_ikoner_version" | xargs)"

      new_version=$(compute_new_version "$current_flagg_ikoner_version" "$2" "$3")

      flagg_ikoner_peer_dep_range="${current_flagg_ikoner_peer_dep#*||}"
      flagg_ikoner_peer_dep_range="${flagg_ikoner_peer_dep_range:+||$flagg_ikoner_peer_dep_range}"

      new_flagg_ikoner_peer_dep="${new_version}${flagg_ikoner_peer_dep_range}"

      echo "Bumping flagg_ikoner from $current_flagg_ikoner_peer_dep to $new_flagg_ikoner_peer_dep..."

      jq --arg newver "$new_flagg_ikoner_peer_dep" \
        '.peerDependencies["@navikt/flagg-ikoner"] = $newver' \
        package.json > tmp.json && mv tmp.json package.json

    fi

    if [ "$package" == "flagg-ikoner" ] || [ "$package" == "landvelger" ]; then
      # Get and increment the "@navikt/land-verktoy" field (patch bump)
      current_version=$(jq -r '.devDependencies["@navikt/land-verktoy"]' package.json)
      new_version=$(compute_new_version "$current_version" "$2" "$3")

      echo "Bumping land-verktoy from $current_version to $new_version..."

      # Update land-verktoy in package.json
      jq --arg newver "$new_version" '.devDependencies["@navikt/land-verktoy"] = $newver' package.json > tmp.json && mv tmp.json package.json

    fi

    if [ "$package" == "landvelger" ]; then
      # Get and increment the "@navikt/flagg-ikoner" field (patch bump)
      current_version=$(jq -r '.devDependencies["@navikt/flagg-ikoner"]' package.json)
      new_version=$(compute_new_version "$current_version" "$2" "$3")

      echo "Bumping flagg-ikoner from $current_version to $new_version..."

      # Update flagg-ikoner in package.json
      jq --arg newver "$new_version" '.devDependencies["@navikt/flagg-ikoner"] = $newver' package.json > tmp.json && mv tmp.json package.json

    fi

    # Get and increment the "version" field (patch bump)
    current_version=$(jq -r '.version' package.json)
    new_version=$(compute_new_version "$current_version" "$2" "$3")

    echo "Bumping version from $current_version to $new_version..."

    # Update the version in package.json
    jq --arg newver "$new_version" '.version = $newver' package.json > tmp.json && mv tmp.json package.json

    rm -rf node_modules
    npm install

    if ! npm run test; then
      echo "Tests failed. Aborting..."
      exit 1
    fi

    if [ "$package" != "fetch-api" ]; then
      npm run build
    fi

    npm run dist

    git add .
    git commit -m "E - New version $CUSTOM_COMMIT_MESSAGE"
    git push

    if [[ "$2" = "wip" || "$3" = "wip" ]]; then
      npm publish --tag wip
    else
      npm publish
    fi

    cd ..
  done

