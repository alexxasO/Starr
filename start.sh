if [ ! -f .env ]; then
    echo "Creating .env file"
    cp .env.example .env
fi

# launch services if arg script-only is not passed
if [ "$1" != "--scripts-only" ]; then
    echo "Launching services"
    docker compose --profile blackhole up -d
fi

./wait-for-it.sh localhost:9696 -- echo "Prowlarr is up"
./wait-for-it.sh localhost:8989 -- echo "Sonarr is up"

# execute all scripts recursively in scripts folder
for script in $(find ./scripts -type f -name "*.sh" | sort); do
    echo "----- Executing script: $script -----"
    bash $script
    echo "----- Finished executing script: $script -----"
done