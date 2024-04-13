param(
    [Parameter(HelpMessage = "File with env variables", Mandatory = $true)]
    [string]
    $EnvFile
)

if (!(Test-Path $EnvFile -PathType Leaf)) {
    Write-Error "$EnvFile is not a file."
    return;
}

Get-Content $EnvFile | ForEach-Object {
    $name, $value = $_.split('=')
    Write-Information "$name=$value"
    Set-Content env:\$name $value
    Write-Output "Writing $name to environment variable with $value."
}

# Définir le chemin de données à partir de la variable d'environnement
$dataPath = $env:DATA_PATH

echo "Echo : $dataPath"

# Créer les répertoires avec le chemin de données personnalisé
mkdir -Force "$dataPath/torrents/books"
mkdir -Force "$dataPath/torrents/movies"
mkdir -Force "$dataPath/torrents/music"
mkdir -Force "$dataPath/torrents/tv"

mkdir -Force "$dataPath/usenet/incomplete"
mkdir -Force "$dataPath/usenet/complete/books"
mkdir -Force "$dataPath/usenet/complete/movies"
mkdir -Force "$dataPath/usenet/complete/music"
mkdir -Force "$dataPath/usenet/complete/tv"

mkdir -Force "$dataPath/media/books"
mkdir -Force "$dataPath/media/movies"
mkdir -Force "$dataPath/media/music"
mkdir -Force "$dataPath/media/tv"
