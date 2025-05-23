function Remove-Directory($directory)
{
	Remove-Item -Path $directory -Force -Recurse -ErrorAction Ignore
}

function Expand-ZipFile($file, $destination)
{
	Remove-Directory $destination
	Expand-Archive -Path $file -DestinationPath $destination
}

function Compress-ZipFile($file, $destination)
{
	Compress-Archive -Path $file -DestinationPath $destination
}
