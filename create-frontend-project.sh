#!/bin/bash

# Creates a vanilla HTML/CSS/JS from a basic template
function create_vanilla_html_css_js_project() {
    echo "Creating Vanilla HTML CSS JS template files..."
    mkdir "css" "js"
    touch "css/style.css" "js/index.js"

    cat <<EOF > "index.html"
<html>
    <head>
        <title>HTML/CSS/JS Vanilla app</title>
        <link rel="stylesheet" href="css/style.css">
        <script src="js/index.js"></script>
    </head>
    <body>
        <p>It works!</p>
    </body>
</html>
EOF
    echo "DONE"
    echo "Vanilla HTML/CSS/JS project created successfully, saving git commit..."
    git add .
    git commit -m "(frontend) :sparkles: Created Vanilla HTML/CSS/JS project from template"
    echo "DONE"
}

# Creates an Angular project with default settings
function create_angular_project() {
    echo "Creating Angular project with latest angular version"

    echo "Installing Angular CLI..."
    npm install --global --save-dev @angular/cli
    echo "DONE"

    echo "Creating the Angular project"
    ng new angular-frontend \
        --directory "." \
        --style "css" \
        --package-manager "npm" \
        --skip-git "true" \
        --skip-tests true \
        --ssr false \
        --standalone \
        --strict \
        --force \
        --defaults
    echo "DONE"

    echo "Angular project created successfully, saving git commit..."
    git add .
    git commit -m "(frontend) :sparkles: Created Angular project from template"
    echo "DONE"
}

# Creates a Ionic + Angular project with default settings
function create_angular_ionic_project() {
    echo "Creating Ionic + Angular project with latest angular and ionic versions"

    echo "Installing required CLI packages..."
    npm install --global --save-dev @angular/cli @ionic/cli native-run cordova-res
    echo "DONE"

    echo "Creating the Ionic + Angular project"
    ionic start frontend tabs \
        --type="angular-standalone" \
        --capacitor \
        --no-interactive \
        --no-git
    echo "DONE"

    echo "Adding default capacitors + PWA Elements"
    npm install @capacitor/camera @capacitor/preferences @capacitor/filesystem @ionic/pwa-elements
    echo "DONE"

    echo "Importing PWA Elements in project main.ts"
    sed -i 's|import { defineCustomElements } from "@ionic/pwa-elements/dist/loader";|import { defineCustomElements } from "@ionic/pwa-elements/dist/loader";\n\ndefineCustomElements(window);|' src/main.ts
    echo "DONE"

    echo "Angular + Ionic project created successfully, saving git commit..."
    git add .
    git commit -m "(frontend) :sparkles: Created Angular project from template"
    echo "DONE"
}

if find frontend -mindepth 1 -maxdepth 1 | read; then
    echo "Frontend directory is not empty. This script will destroy its contents."
    echo "Are you absolutely sure? (Y/n)"

    read answer
    if [ "$answer" != "Y" ]; then
        echo "Aborting"
        exit 0
    fi
fi

rm -rf frontend
mkdir -p frontend || true

project_root="$(pwd)"
framework_flag="$1"

cd frontend

case "$framework_flag" in
    "") create_vanilla_html_css_js_project;;
    --html-css-js) create_vanilla_html_css_js_project;;
    --angular) create_angular_project;;
    --angular-ionic) create_angular_ionic_project;;
esac

cd "$project_root"
