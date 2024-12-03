# launch services
docker compose up -d

# execute all scripts recursively in scripts folder
for script in $(find ./scripts -type f -name "*.sh" | sort); do
    echo "----- Executing script: $script -----"
    bash $script
    echo "----- Finished executing script: $script -----"
done