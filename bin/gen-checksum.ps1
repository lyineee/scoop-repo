$path_obj=Get-Location
$current_path=$path_obj.Path
$checksum_file_name="checksum.txt"
if(-not $args[0]){
    Write-Host "no input dir, use current dir to work"
    $root_path=$current_path
}else {
    $root_path=$args[0]
}
$root_path=Resolve-Path $root_path
Write-Host "working dir:" $root_path
$checksum_file_location=-join($root_path,$checksum_file_name)
if(Test-Path $checksum_file_location){
    Remove-Item $checksum_file_location
    Write-Host "remove previous checksum file"
}
$file_list = Get-ChildItem -recurse $root_path | ForEach-Object -Process { if ($_.Attributes -ne "Directory") { Write-Output $_ } }
$file_list | ForEach-Object -Process{
    Set-Location (Split-Path -Path $_.FullName)
    Write-Host "calculating file" $_.Name
    sha256sum.exe $_.Name >> $checksum_file_location
}
Write-Host "gen checksum file at:" $checksum_file_location
Set-Location $current_path