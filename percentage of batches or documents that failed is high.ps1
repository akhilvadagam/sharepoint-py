# SharePoint site URL and list names
$siteUrl = "https://your-sharepoint-site-url.com"
$itemsListName = "KQP_OFFICE_SEARCH_FAST_CONTENT_PLUGIN"
$batchesListName = "KQP_OFFICE_SEARCH_FAST_CONTENT_PLUGIN"

# Authentication (adjust as needed)
Connect-PnPOnline -Url $siteUrl -UseWebLogin

function Get-FailurePercentage {
    param (
        [string]$listName,
        [string]$fieldName
    )

    $items = Get-PnPListItem -List $listName -Fields $fieldName
    if ($items.Count -eq 1) {
        return [float]$items[0][$fieldName]
    }
}

 function Check-FailurePercentage {
    param (
        [float]$itemsFailPercent,
        [float]$batchesFailPercent,
        [int]$threshold = 50
    )

    if ($itemsFailPercent -ge $threshold -or $batchesFailPercent -ge $threshold) {
        return $true
    } else {
        return $false
    }
}

try {
    $itemsFailPercent = Get-FailurePercentage -listName $itemsListName -fieldName "Items_Fail_PerCent"
    $batchesFailPercent = Get-FailurePercentage -listName $batchesListName -fieldName "Batches_Fail_PerCent"

    if (Check-FailurePercentage -itemsFailPercent $itemsFailPercent -batchesFailPercent $batchesFailPercent) {
        Write-Host "Percentage of batches or documents that failed is high."
    } else {
        Write-Host "Percentage of batches or documents that failed is not high."
    }
} catch {
    Write-Host "An error occurred: $_"
}

# Disconnect from SharePoint
Disconnect-PnPOnline