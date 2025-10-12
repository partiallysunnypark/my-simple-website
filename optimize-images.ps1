# Image Optimization Script for Sandra's Art Gallery
# This script resizes images to max 1200px width and compresses them using ImageMagick

Write-Host "Starting image optimization..." -ForegroundColor Green

# Create optimized folder
$optimizedPath = "C:\dev\my-simple-website\images\optimized"
if (!(Test-Path $optimizedPath)) {
    New-Item -ItemType Directory -Path $optimizedPath -Force
    Write-Host "Created optimized folder: $optimizedPath" -ForegroundColor Yellow
}

# Get all image files
$imageFiles = Get-ChildItem "C:\dev\my-simple-website\images" -Include "*.jpg", "*.jpeg", "*.JPG", "*.png", "*.PNG" -File

Write-Host "Found $($imageFiles.Count) images to optimize..." -ForegroundColor Cyan

foreach ($file in $imageFiles) {
    $inputPath = $file.FullName
    $outputPath = Join-Path $optimizedPath $file.Name
    
    Write-Host "Processing: $($file.Name)" -ForegroundColor White
    
    # Get original size
    $originalSize = [math]::Round($file.Length / 1MB, 2)
    
    # Use ImageMagick to resize and compress
    # -resize 1200x1200> : resize to max 1200px width/height, only if larger
    # -quality 80 : compress to 80% quality
    # -strip : remove metadata to save space
    magick "$inputPath" -resize 1200x1200`> -quality 80 -strip "$outputPath"
    
    if (Test-Path $outputPath) {
        $newSize = [math]::Round((Get-Item $outputPath).Length / 1MB, 2)
        $savings = [math]::Round((($originalSize - $newSize) / $originalSize) * 100, 1)
        Write-Host "  ✓ $($file.Name): $originalSize MB → $newSize MB (saved $savings%)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to process $($file.Name)" -ForegroundColor Red
    }
}

# Calculate total savings
$originalTotal = ($imageFiles | Measure-Object Length -Sum).Sum / 1MB
$optimizedFiles = Get-ChildItem $optimizedPath -Include "*.jpg", "*.jpeg", "*.JPG", "*.png", "*.PNG" -File
$optimizedTotal = ($optimizedFiles | Measure-Object Length -Sum).Sum / 1MB

Write-Host "`nOptimization Complete!" -ForegroundColor Green
Write-Host "Original total: $([math]::Round($originalTotal, 2)) MB" -ForegroundColor Yellow
Write-Host "Optimized total: $([math]::Round($optimizedTotal, 2)) MB" -ForegroundColor Yellow
Write-Host "Total savings: $([math]::Round((($originalTotal - $optimizedTotal) / $originalTotal) * 100, 1))%" -ForegroundColor Cyan
Write-Host "`nOptimized images are in: $optimizedPath" -ForegroundColor Magenta
        $image.Dispose()
        
        Write-Host "✓ Saved: $($file.Name) (${newWidth}x${newHeight})"
    }
    catch {
        Write-Host "✗ Error processing $($file.Name): $($_.Exception.Message)"
    }
}

Write-Host "`nOptimization complete! Check the 'optimized' folder."