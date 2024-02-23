$LOG_FILE="$(($pwd).Path)\history.log"

date | Tee-Object -FilePath $LOG_FILE
echo "Update braches begin..." | Tee-Object -FilePath $LOG_FILE -Append

$lastRemoteAndBranches = $null
$reposAndBranches = Get-Content -Path '.\repo.ini' | ForEach-Object {
    if (($_ -match '^#') -or (!$_)) { return }
	
    $line = $_.Trim()
	$parts = $line -split '\s+'
	if ($parts.Count -gt 2) {
		$remote = $parts[1]
		$localBranches = $parts[2..($parts.Count - 1)]
		$lastRemoteAndBranches = $remote, $localBranches
	} else {
		$remote = $lastRemoteAndBranches[0]
		$localBranches = $lastRemoteAndBranches[1]
	}
	[PSCustomObject]@{
		Repository = $parts[0]
		Remote = $remote
		LocalBranches = $localBranches
	}
}
echo $reposAndBranches *>&1 | Tee-Object -FilePath $LOG_FILE -Append

foreach ($entry in $reposAndBranches) {
    echo "Updating $($entry.Repository)..." | Tee-Object -FilePath $LOG_FILE -Append
    Push-Location -Path $($entry.Repository)
	$repoName = $(Get-Item $($entry.Repository)).Name
	git fetch $($entry.Remote) *>&1 | Tee-Object -FilePath $LOG_FILE -Append

    foreach ($localBranch in $entry.LocalBranches) {
        if (git branch --list $localBranch) {
            echo "Local $repoName/$localBranch exists, updating from remote $($entry.Remote)" | Tee-Object -FilePath $LOG_FILE -Append
            git checkout $localBranch *>&1 | Tee-Object -FilePath $LOG_FILE -Append
			git pull $($entry.Remote) $localBranch *>&1 | Tee-Object -FilePath $LOG_FILE -Append
        } else {
            echo "No local $repoName/$localBranch found, checking out from remote $($entry.Remote)" | Tee-Object -FilePath $LOG_FILE -Append
			git checkout -b $localBranch "remotes/$($entry.Remote)/$localBranch" *>&1 | Tee-Object -FilePath $LOG_FILE -Append
        }
    }

    Pop-Location
}

echo "Update braches end..." | Tee-Object -FilePath $LOG_FILE -Append
