# PowerShell script to optimize new artwork images
# Place your downloaded images in resources/images/art/new/ directory
# Name them: IBelong.jpg, Blueberries.jpg, Fairy.jpg

Write-Host "=== New Artwork Image Optimization ==="
Write-Host "Checking for new artwork files..."

$sourceDir = "resources/images/art/new"
$destDir = "resources/images/art"

# Check if source directory exists
if (-not (Test-Path $sourceDir)) {
    Write-Host "Creating source directory: $sourceDir"
    New-Item -ItemType Directory -Path $sourceDir -Force
}

# List of expected new artwork files
$artworkFiles = @("IBelong.jpg", "Blueberries.jpg", "Fairy.jpg")

foreach ($file in $artworkFiles) {
    $sourcePath = Join-Path $sourceDir $file
    $destPath = Join-Path $destDir $file

    if (Test-Path $sourcePath) {
        Write-Host "Processing $file..."

        # Optimize with ImageMagick
        & magick "$sourcePath" -resize 800x800> -quality 85 "$destPath"

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Successfully optimized $file"

            # Get file sizes for comparison
            $originalSize = (Get-Item $sourcePath).Length
            $optimizedSize = (Get-Item $destPath).Length
            $reduction = [math]::Round((($originalSize - $optimizedSize) / $originalSize) * 100, 1)

            Write-Host "   Original: $([math]::Round($originalSize/1KB, 1)) KB"
            Write-Host "   Optimized: $([math]::Round($optimizedSize/1KB, 1)) KB"
            Write-Host "   Reduction: $reduction%"
        } else {
            Write-Host "❌ Failed to optimize $file"
        }
    } else {
        Write-Host "⚠️  File not found: $file"
        Write-Host "   Please download and place in: $sourceDir"
    }
    Write-Host ""
}

Write-Host "=== Optimization Complete ==="
Write-Host "Next step: Add the new artworks to art.html"