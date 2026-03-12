 # Define the packages to update
  packages=("land-verktoy" "flagg-ikoner" "landvelger")  # <-- Update the rest as needed

  if [ -z "$1" ]; then
      echo "Usage: bumpPackage"
      return 1
  fi

  CUSTOM_COMMIT_MESSAGE=$1

  for package in "${packages[@]}"; do

    echo "Updating $package..."
    cd "$package" || continue

    if ! command -v jq >/dev/null 2>&1; then
        echo "Error: jq is required but not installed."
        return 1
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

      current_land_verktoy_version_no_wip="${current_land_verktoy_version%-wip}"
      IFS='.' read -r major minor patch <<< "$current_land_verktoy_version_no_wip"

      if [ "$2" = "wip" ]; then
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
        new_version="${new_version}-wip"
      elif [ "$2" = "major" ]; then
        new_major=$((major + 1))
        new_minor=0
        new_patch=0
        new_version="$new_major.$new_minor.$new_patch"
      elif [ "$2" = "minor" ]; then
        new_minor=$((minor + 1))
        new_patch=0
        new_version="$major.$new_minor.$new_patch"
      else
        if [[ "$current_version" == *"-wip" ]]; then
          new_minor=$((minor + 1))
          new_patch=0
          new_version="$major.$new_minor.$new_patch"
        else
          new_patch=$((patch + 1))
          new_version="$major.$minor.$new_patch"
        fi
      fi

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

      current_flagg_ikoner_version_no_wip="${current_flagg_ikoner_version%-wip}"
      IFS='.' read -r major minor patch <<< "$current_flagg_ikoner_version_no_wip"

      if [ "$2" = "wip" ]; then
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
        new_version="${new_version}-wip"
      elif [ "$2" = "major" ]; then
        new_major=$((major + 1))
        new_minor=0
        new_patch=0
        new_version="$new_major.$new_minor.$new_patch"
      elif [ "$2" = "minor" ]; then
        new_minor=$((minor + 1))
        new_patch=0
        new_version="$major.$new_minor.$new_patch"
      else
        if [[ "$current_version" == *"-wip" ]]; then
          new_minor=$((minor + 1))
          new_patch=0
          new_version="$major.$new_minor.$new_patch"
        else
          new_patch=$((patch + 1))
          new_version="$major.$minor.$new_patch"
        fi
      fi

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
      current_version_without_wip="${current_version%-wip}"
      IFS='.' read -r major minor patch <<< "$current_version_without_wip"

      if [ "$2" = "wip" ]; then
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
        new_version="${new_version}-wip"
      elif [ "$2" = "major" ]; then
        new_major=$((major + 1))
        new_minor=0
        new_patch=0
        new_version="$new_major.$new_minor.$new_patch"
      elif [ "$2" = "minor" ]; then
        new_minor=$((minor + 1))
        new_patch=0
        new_version="$major.$new_minor.$new_patch"
      else
        if [[ "$current_version" == *"-wip" ]]; then
          new_minor=$((minor + 1))
          new_patch=0
          new_version="$major.$new_minor.$new_patch"
        else
          new_patch=$((patch + 1))
          new_version="$major.$minor.$new_patch"
        fi
      fi

      echo "Bumping land-verktoy from $current_version to $new_version..."

      # Update land-verktoy in package.json
      jq --arg newver "$new_version" '.devDependencies["@navikt/land-verktoy"] = $newver' package.json > tmp.json && mv tmp.json package.json

    fi

    if [ "$package" == "landvelger" ]; then
      # Get and increment the "@navikt/flagg-ikoner" field (patch bump)
      current_version=$(jq -r '.devDependencies["@navikt/flagg-ikoner"]' package.json)
      current_version_without_wip="${current_version%-wip}"
      IFS='.' read -r major minor patch <<< "$current_version_without_wip"

      if [ "$2" = "wip" ]; then
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
        new_version="${new_version}-wip"
      elif [ "$2" = "major" ]; then
        new_major=$((major + 1))
        new_minor=0
        new_patch=0
        new_version="$new_major.$new_minor.$new_patch"
      elif [ "$2" = "minor" ]; then
        new_minor=$((minor + 1))
        new_patch=0
        new_version="$major.$new_minor.$new_patch"
      else
        if [[ "$current_version" == *"-wip" ]]; then
          new_minor=$((minor + 1))
          new_patch=0
          new_version="$major.$new_minor.$new_patch"
        else
          new_patch=$((patch + 1))
          new_version="$major.$minor.$new_patch"
        fi
      fi

      echo "Bumping flagg-ikoner from $current_version to $new_version..."

      # Update flagg-ikoner in package.json
      jq --arg newver "$new_version" '.devDependencies["@navikt/flagg-ikoner"] = $newver' package.json > tmp.json && mv tmp.json package.json

    fi

    # Get and increment the "version" field (patch bump)
    current_version=$(jq -r '.version' package.json)
    current_version_without_wip="${current_version%-wip}"
    IFS='.' read -r major minor patch <<< "$current_version_without_wip"

    if [ "$2" = "wip" ]; then
      new_patch=$((patch + 1))
      new_version="$major.$minor.$new_patch"
      new_version="${new_version}-wip"
    elif [ "$2" = "major" ]; then
      new_major=$((major + 1))
      new_minor=0
      new_patch=0
      new_version="$new_major.$new_minor.$new_patch"
    elif [ "$2" = "minor" ]; then
      new_minor=$((minor + 1))
      new_patch=0
      new_version="$major.$new_minor.$new_patch"
    else
      if [[ "$current_version" == *"-wip" ]]; then
        new_minor=$((minor + 1))
        new_patch=0
        new_version="$major.$new_minor.$new_patch"
      else
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
      fi
    fi

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
    git commit -m "U - New version $CUSTOM_COMMIT_MESSAGE"
    git push

    if [ "$2" = "wip" ]; then
      npm publish --tag wip
    else
      npm publish
    fi

    cd ..
  done

