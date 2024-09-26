# Define the directory to search and replace
$sourceDirectory = "C:\Users\jouqu\Documents\Dev\Starr"
$replacementPath = "D:"

# Define the file extension filter
$fileExtensionFilter = "*.yaml" # Change this to match the file types you want to search in

# Get all files recursively in the source directory with the specified file extension
$files = Get-ChildItem -Path $sourceDirectory -Recurse -Filter $fileExtensionFilter

# Iterate through each file
foreach ($file in $files) {
    # Read the content of the file
    $content = Get-Content -Path $file.FullName

    # Perform the replacement
    $newContent = $content -replace [regex]::Escape($sourceDirectory), $replacementPath

    # Write the updated content back to the file
    Set-Content -Path $file.FullName -Value $newContent
}

Write-Host "Replacement completed."
