$ErrorActionPreference = 'Stop'
Import-Module '%%WORKSRCPATH%%/build.psm1' -Force
Copy-PSGalleryModules -CsProjPath '%%WORKSRCPATH%%/src/Modules/PSGalleryModules.csproj' -Destination '%%PUBLISHPATH%%/Modules' -Force