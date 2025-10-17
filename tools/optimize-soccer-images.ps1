# Soccer Image Optimization Script
# This script optimizes soccer images for the website

Write-Host "Starting soccer image optimization..." -ForegroundColor Green

# Create soccer images folder
$soccerImagesPath = "C:\dev\my-simple-website\resources\images\soccer"
if (!(Test-Path $soccerImagesPath)) {
    New-Item -ItemType Directory -Path $soccerImagesPath -Force
    Write-Host "Created soccer images folder: $soccerImagesPath" -ForegroundColor Yellow
}

# Source folder for downloaded soccer images
$sourcePath = "C:\Users\keli_\Downloads\Soccer"  # Your soccer images folder
Write-Host "Looking for images in: $sourcePath" -ForegroundColor Cyan

if (!(Test-Path $sourcePath)) {
    Write-Host "Downloads folder not found! Please:" -ForegroundColor Red
    Write-Host "1. Go to: https://drive.google.com/drive/u/1/folders/1ToJ21KT4EUYth12gO-63jKwpnT18mvAe" -ForegroundColor Yellow
    Write-Host "2. Download soccer images to your Downloads folder" -ForegroundColor Yellow
    Write-Host "3. Run this script again" -ForegroundColor Yellow
    exit
}

# Get all image files including HEIC
$imageFiles = Get-ChildItem $sourcePath -Include "*.jpg", "*.jpeg", "*.JPG", "*.png", "*.PNG", "*.heic", "*.HEIC" -File -Recurse

Write-Host "Found $($imageFiles.Count) soccer images to optimize..." -ForegroundColor Cyan

foreach ($file in $imageFiles) {
    $inputPath = $file.FullName
    $outputPath = Join-Path $soccerImagesPath $file.Name
    
    Write-Host "Processing: $($file.Name)" -ForegroundColor White
    
    # Get original size
    $originalSize = [math]::Round($file.Length / 1MB, 2)
    
    # Convert HEIC files to JPG, others keep original format
    if ($file.Extension -eq ".HEIC" -or $file.Extension -eq ".heic") {
        $outputPath = Join-Path $soccerImagesPath ($file.BaseName + ".jpg")
    }
    
    # Use ImageMagick to resize and compress
    # -resize 800x800> : resize to max 800px for web display
    # -quality 85 : compress to 85% quality for soccer photos
    # -strip : remove metadata
    # -format jpg : convert HEIC to JPG
    try {
        & magick "$inputPath" -resize "800x800>" -quality 85 -strip -format jpg "$outputPath"
        
        if (Test-Path $outputPath) {
            $newSize = [math]::Round((Get-Item $outputPath).Length / 1MB, 2)
            $savings = [math]::Round((($originalSize - $newSize) / $originalSize) * 100, 1)
            $fileType = if ($file.Extension -match "heic|HEIC") { "(HEIC->JPG)" } else { "" }
            Write-Host "  SUCCESS: $($file.Name) ${fileType} - ${originalSize}MB to ${newSize}MB (${savings}% smaller)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  ERROR: Failed to process $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nSoccer image optimization complete!" -ForegroundColor Green
Write-Host "Images saved to: $soccerImagesPath" -ForegroundColor Cyan