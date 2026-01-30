   # Define the packages to update
    packages=("tabell" "fetch-api" "land-verktoy" "flagg-ikoner" "landvelger")  # <-- Update the rest as needed

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
	  # Get and increment the "@navikt/land-verktoy" field (patch bump)
          current_version=$(jq -r '.devDependencies["@navikt/land-verktoy"]' package.json)
            IFS='.' read -r major minor patch <<< "$current_version"
          new_patch=$((patch + 1))
          new_version="$major.$minor.$new_patch"
          echo "Bumping land-verktoy from $current_version to $new_version..."

          # Update land-verktoy in package.json
          jq --arg newver "$new_version" '.devDependencies["@navikt/land-verktoy"] = $newver' package.json > tmp.json && mv tmp.json package.json
	
        fi

	if [ "$package" == "landvelger" ]; then
	  # Get and increment the "@navikt/flagg-ikoner" field (patch bump)
          current_version=$(jq -r '.devDependencies["@navikt/flagg-ikoner"]' package.json)
            IFS='.' read -r major minor patch <<< "$current_version"
          new_patch=$((patch + 1))
          new_version="$major.$minor.$new_patch"
          echo "Bumping flagg-ikoner from $current_version to $new_version..."

          # Update flagg-ikoner in package.json
          jq --arg newver "$new_version" '.devDependencies["@navikt/flagg-ikoner"] = $newver' package.json > tmp.json && mv tmp.json package.json

        fi


        # Get and increment the "version" field (patch bump)
        current_version=$(jq -r '.version' package.json)
        IFS='.' read -r major minor patch <<< "$current_version"
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
        echo "Bumping version from $current_version to $new_version..."

        # Update the version in package.json
        jq --arg newver "$new_version" '.version = $newver' package.json > tmp.json && mv tmp.json package.json

	rm -rf node_modules
        npm install

        if ! npm run test; then
          echo "Tests failed. Aborting..."
          exit 1
        fi

        npm run build
        npm run dist

        git add .
        git commit -m "U - New version $CUSTOM_COMMIT_MESSAGE"
        git push

        npm publish

        cd ..
   done

