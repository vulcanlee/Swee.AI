$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $repoRoot 'index.html'
$cssPath = Join-Path $repoRoot 'assets/site.css'
$faviconPath = Join-Path $repoRoot 'assets/favicon.svg'
$docInsightPath = Join-Path $repoRoot 'products/docinsight.html'
$knowledgeExtractionPath = Join-Path $repoRoot 'products/knowledge-extraction.html'
$readmePath = Join-Path $repoRoot 'README.md'
$workflowPath = Join-Path $repoRoot '.github/workflows/azure-static-web-apps-green-mushroom-0c8aeb200.yml'

$sourceDocInsight = 'D:\Vulcan\GitHub\DocInsight.AI\docs\marketing\產品介紹簡報.html'
$sourceKnowledgeExtraction = 'D:\Vulcan\GitHub\KnowledgeExtraction.AI\docs\marketing\商業簡報-對外銷售版.html'

function Assert-True {
    param(
        [Parameter(Mandatory)] [bool] $Condition,
        [Parameter(Mandatory)] [string] $Message
    )

    if (-not $Condition) {
        throw "FAIL: $Message"
    }
}

function Get-CssMediaBlock {
    param(
        [Parameter(Mandatory)] [string] $Stylesheet,
        [Parameter(Mandatory)] [string] $QueryPattern
    )

    $mediaMatch = [regex]::Match(
        $Stylesheet,
        "@media\s*\(\s*$QueryPattern\s*\)\s*\{",
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    if (-not $mediaMatch.Success) {
        return $null
    }

    $openingBrace = $Stylesheet.IndexOf('{', $mediaMatch.Index)
    $depth = 0

    for ($index = $openingBrace; $index -lt $Stylesheet.Length; $index++) {
        if ($Stylesheet[$index] -eq '{') {
            $depth++
        }
        elseif ($Stylesheet[$index] -eq '}') {
            $depth--

            if ($depth -eq 0) {
                return $Stylesheet.Substring($mediaMatch.Index, $index - $mediaMatch.Index + 1)
            }
        }
    }

    return $null
}

foreach ($requiredFile in @($indexPath, $cssPath, $faviconPath, $docInsightPath, $knowledgeExtractionPath, $readmePath, $workflowPath)) {
    Assert-True (Test-Path -LiteralPath $requiredFile -PathType Leaf) "Missing required file: $requiredFile"
}

$index = Get-Content -Raw -LiteralPath $indexPath
$css = Get-Content -Raw -LiteralPath $cssPath
$favicon = Get-Content -Raw -LiteralPath $faviconPath
$workflow = Get-Content -Raw -LiteralPath $workflowPath
$anchorTags = @([regex]::Matches($index, '<a\b[^>]*>') | ForEach-Object { $_.Value })
$imageTags = @([regex]::Matches($index, '<img\b[^>]*>') | ForEach-Object { $_.Value })
$playlistOneUrl = 'https://www.youtube.com/playlist?list=PLPjPfeIYN_Lc'
$playlistTwoUrl = 'https://www.youtube.com/playlist?list=PLLElWCjgPInk'
$playlistOneTag = $anchorTags | Where-Object { $_.Contains("href=`"$playlistOneUrl`"") } | Select-Object -First 1
$playlistTwoTag = $anchorTags | Where-Object { $_.Contains("href=`"$playlistTwoUrl`"") } | Select-Object -First 1
$playlistOneImage = $imageTags | Where-Object { $_.Contains('src="https://i.ytimg.com/vi/j2Y8_6pCwBM/hqdefault.jpg"') } | Select-Object -First 1
$playlistTwoImage = $imageTags | Where-Object { $_.Contains('src="https://i.ytimg.com/vi/dTrEHvsHf0k/hqdefault.jpg"') } | Select-Object -First 1
$playTags = @([regex]::Matches($index, '<span\b(?=[^>]*\bclass="playlist-card__play")[^>]*>') | ForEach-Object { $_.Value })
$mobileBlock = Get-CssMediaBlock -Stylesheet $css -QueryPattern 'max-width:\s*640px'
$reducedMotionBlock = Get-CssMediaBlock -Stylesheet $css -QueryPattern 'prefers-reduced-motion:\s*reduce'

Assert-True ($index -match '<html\s+lang="zh-Hant"') 'Homepage language must be zh-Hant.'
Assert-True ($index -match '<title>企業 AI 產品中心</title>') 'Homepage title is missing or incorrect.'
Assert-True ($index -match 'rel="icon"[^>]+href="assets/favicon\.svg"') 'SVG favicon link is missing.'
Assert-True ($index -match '讓企業文件與知識，\s*(?:<br\s*/?>)?\s*真正成為可用的智慧') 'Hero headline is missing.'
Assert-True ($index -match 'DocInsight 智閱引擎') 'DocInsight product card is missing.'
Assert-True ($index -match 'KnowledgeExtraction\.AI 智庫引擎') 'KnowledgeExtraction product card is missing.'
Assert-True ($index -match '更多企業 AI 應用，\s*<span>敬請期待</span>') 'Coming Soon card is missing.'
Assert-True ($index -match 'href="products/docinsight\.html"[^>]+target="_blank"[^>]+rel="noopener"') 'DocInsight link must open safely in a new tab.'
Assert-True ($index -match 'href="products/knowledge-extraction\.html"[^>]+target="_blank"[^>]+rel="noopener"') 'KnowledgeExtraction link must open safely in a new tab.'
$videoSection = [regex]::Match($index, '(?s)<section\b(?=[^>]*\bclass="video-resources")(?=[^>]*\baria-labelledby="video-resources-title")[^>]*>(.*?)</section>')
Assert-True ($videoSection.Success) 'Video resources section must reference video-resources-title with aria-labelledby.'
Assert-True ($videoSection.Groups[1].Value -match '<h2\s+id="video-resources-title">從影片看見知識庫應用</h2>') 'Video resources section must contain its labelled heading.'
Assert-True ($index -match '30種企業知識庫應用') 'Cross-industry playlist title is missing.'
Assert-True ($index -match '智庫引擎 企業知識庫') 'Knowledge engine playlist title is missing.'
Assert-True ($null -ne $playlistOneTag) 'Cross-industry playlist link must use the exact case-sensitive URL.'
Assert-True ($playlistOneTag.Contains('target="_blank"')) 'Cross-industry playlist link must open in a new tab.'
Assert-True ($playlistOneTag.Contains('rel="noopener"')) 'Cross-industry playlist link must use noopener.'
Assert-True ($null -ne $playlistTwoTag) 'Knowledge engine playlist link must use the exact case-sensitive URL.'
Assert-True ($playlistTwoTag.Contains('target="_blank"')) 'Knowledge engine playlist link must open in a new tab.'
Assert-True ($playlistTwoTag.Contains('rel="noopener"')) 'Knowledge engine playlist link must use noopener.'
Assert-True ($null -ne $playlistOneImage) 'Cross-industry playlist thumbnail must use the expected image URL.'
Assert-True ($playlistOneImage.Contains('loading="lazy"')) 'Cross-industry playlist thumbnail must load lazily.'
Assert-True ($playlistOneImage.Contains('alt=""')) 'Cross-industry playlist thumbnail must be decorative.'
Assert-True ($null -ne $playlistTwoImage) 'Knowledge engine playlist thumbnail must use the expected image URL.'
Assert-True ($playlistTwoImage.Contains('loading="lazy"')) 'Knowledge engine playlist thumbnail must load lazily.'
Assert-True ($playlistTwoImage.Contains('alt=""')) 'Knowledge engine playlist thumbnail must be decorative.'
Assert-True ($playTags.Count -eq 2) 'Both playlist cards must include a CSS play symbol.'
Assert-True ((@($playTags | Where-Object { $_.Contains('aria-hidden="true"') })).Count -eq 2) 'Both CSS play symbols must be hidden from assistive technology.'
Assert-True ($index -notmatch '<script\b') 'Homepage must not require JavaScript.'
Assert-True ($index -notmatch '<iframe\b') 'Homepage must not embed iframes.'

Assert-True ($css -match '@media\s*\(max-width:\s*900px\)') 'Tablet breakpoint is missing.'
Assert-True ($null -ne $mobileBlock) 'Mobile breakpoint is missing.'
Assert-True ($null -ne $reducedMotionBlock) 'Reduced-motion support is missing.'
Assert-True ($reducedMotionBlock -match '(?s)\*\s*,\s*\*::before\s*,\s*\*::after\s*\{[^}]*transition-duration:\s*0\.01ms\s*!important') 'Reduced-motion support must minimize all transition durations.'
Assert-True ($css -match ':focus-visible') 'Keyboard focus styling is missing.'
Assert-True ($css -match '(?s)@media\s*\(max-width:\s*900px\).*?\.product-card--soon\s*\{[^}]*grid-column:\s*1\s*/\s*-1') 'Coming Soon card must span both tablet columns.'
Assert-True ($css -match '(?s)@media\s*\(max-width:\s*640px\).*?\.product-card--soon\s*\{[^}]*grid-column:\s*auto') 'Coming Soon card must return to one column on mobile.'
Assert-True ($css -match '(?s)\.playlist-grid\s*\{[^}]*grid-template-columns:\s*repeat\(2,\s*minmax\(0,\s*1fr\)\)') 'Playlist grid must use two columns.'
Assert-True ($mobileBlock -match '(?s)\.playlist-grid\s*\{[^}]*grid-template-columns:\s*1fr') 'Playlist grid must return to one column inside the mobile breakpoint.'

Assert-True ($favicon -match '<svg\b') 'Favicon must be SVG.'
Assert-True ($favicon -match 'aria-hidden="true"') 'Decorative favicon must be hidden from assistive technology.'

$sourceDocHash = (Get-FileHash -LiteralPath $sourceDocInsight -Algorithm SHA256).Hash
$copiedDocHash = (Get-FileHash -LiteralPath $docInsightPath -Algorithm SHA256).Hash
$sourceKnowledgeHash = (Get-FileHash -LiteralPath $sourceKnowledgeExtraction -Algorithm SHA256).Hash
$copiedKnowledgeHash = (Get-FileHash -LiteralPath $knowledgeExtractionPath -Algorithm SHA256).Hash

Assert-True ($sourceDocHash -eq $copiedDocHash) 'DocInsight product page differs from its source.'
Assert-True ($sourceKnowledgeHash -eq $copiedKnowledgeHash) 'KnowledgeExtraction product page differs from its source.'

Assert-True ($workflow -match 'uses:\s*actions/checkout@v6') 'Deployment workflow must use the Node.js 24-compatible checkout action.'
Assert-True ($workflow -notmatch 'actions/github-script') 'Deployment workflow must not use the obsolete OIDC GitHub Script step.'
Assert-True ($workflow -notmatch 'npm\s+install\s+@actions/core') 'Deployment workflow must not create a transient Node.js project.'
Assert-True ($workflow -notmatch 'github_id_token') 'Deployment workflow must not pass the unsupported github_id_token input.'
Assert-True ($workflow -notmatch '(?m)^\s*id-token\s*:') 'Deployment workflow must not request unused OIDC permissions.'
Assert-True ($workflow -match '(?m)^\s*contents\s*:\s*read\s*$') 'Deployment workflow must use read-only contents permission.'
Assert-True ($workflow -match '(?m)^\s*pull-requests\s*:\s*write\s*$') 'Deployment workflow must allow pull request integration.'
Assert-True ($workflow -match '(?m)^\s*issues\s*:\s*write\s*$') 'Deployment workflow must allow deployment status comments.'
Assert-True ($workflow -match '(?m)^\s*repo_token\s*:\s*\$\{\{\s*secrets\.GITHUB_TOKEN\s*\}\}\s*$') 'Upload deployment must pass the GitHub repository token.'
Assert-True ($workflow -match '(?m)^\s*app_location\s*:\s*"/"\s*(?:#.*)?$') 'Static app location must point to the repository root.'
Assert-True ($workflow -match '(?m)^\s*api_location\s*:\s*""\s*(?:#.*)?$') 'Static deployment must not define an API location.'
Assert-True ($workflow -match '(?m)^\s*output_location\s*:\s*""\s*(?:#.*)?$') 'Static deployment output location must be empty.'
Assert-True ($workflow -match '(?m)^\s*skip_app_build\s*:\s*true\s*$') 'Static deployment must skip the Oryx application build.'
$deploymentTokenPattern = '(?m)^\s*azure_static_web_apps_api_token\s*:\s*\$\{\{\s*secrets\.AZURE_STATIC_WEB_APPS_API_TOKEN_GREEN_MUSHROOM_0C8AEB200\s*\}\}\s*$'
Assert-True ([regex]::Matches($workflow, $deploymentTokenPattern).Count -eq 2) 'Upload and pull request cleanup jobs must both pass the Azure deployment token.'

Write-Output 'PASS: static site and Azure Static Web Apps workflow are valid.'
