# WARNING, THIS SCRIPT ASSUMES YOU HAVE godot IN YOUR PATH
$confirmation = Read-Host -Prompt "WARNING, this script assumes you have 'godot' as an executable in your path. Continue? (y/n)"
if ($confirmation -ne "y") {
    Write-Host "Exiting..."
    exit
}
Write-Host "Cleaning docs..."
# First, clean docs folder
Remove-Item .\docs\automatic\* -Force
# Second, generate docs
Write-Host "Generating docs..."
godot --doctool .\docs\automatic\ --gdscript-docs res://.
Write-Host "Done!"
