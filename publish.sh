typst compile --format bundle --features bundle,html main.typ
cd main
git add .
git commit -am "Publish"
git push
cd ..
