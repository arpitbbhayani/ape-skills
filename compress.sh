for dir in */ ; do
    zip -r "${dir%/}.zip" "$dir"
done

cp *.zip /mnt/c/Users/arpit/Documents/skills/
rm *.zip
