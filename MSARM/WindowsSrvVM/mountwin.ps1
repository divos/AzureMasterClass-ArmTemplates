$connectTestResult = Test-NetConnection -ComputerName saquestitlabsshare.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"10.250.5.8`" /user:`"Azure\saquestitlabsshare`" /pass:`"/0FAmAoVjcUDc3EMclEVhqfrzYgdG1AoR7SGk6CWc50w+2x5shN75vqfqhDaW6Sa8TLunD7p7H85CQDlJt/8Pw==`""
    # Mount the drive
    New-PSDrive -Name W -PSProvider FileSystem -Root "\\10.250.5.8\internal-share" -Persist -scope Global
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}