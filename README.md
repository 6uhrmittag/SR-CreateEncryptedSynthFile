# Powershell Script to encrypt a custom draft for Synth Riders

1. Install 7zip: `winget install -e --id 7zip.7zip`
2. open PowerShell
3. go to the directory where your `*.synth` files are located (`cd "C:\Program Files (x86)\Steam\steamapps\common\Synth Riders Beatmap Editor\CustomSongs"`)
4. put `Encrypt-Song.ps1` in the same directory (`Invoke-WebRequest https://raw.githubusercontent.com/6uhrmittag/SR-CreateEncryptedSynthFile/refs/heads/main/Encrypt-Song.ps1 -OutFile Encrypt-Song.ps1`)
5. run the script with `./Encrypt-Song.ps1 -Password nobodyknows -SongFile .\unencryptedDraft.synth`
6. the encrypted file will be created in a new directory called `EncryptedSongs` (can be changed with `-OutputDirectory`)
7. share encrypted file and put it in `C:\Program Files (x86)\Steam\steamapps\common\SynthRiders\SynthRidersUC\CustomSongs`