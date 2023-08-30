# Install chocolatey on windows

Refer to [this](https://chocolatey.org/install) page.

1. First, ensure that you are using an administrative shell.
2. Install with powershell.exe
3. With PowerShell, you must ensure `Get-ExecutionPolicy` is not Restricted. It's better to use `Bypass` to bypass the policy to get things installed or `AllSigned` for quite a bit more security.
   - Run `Get-ExecutionPolicy`. If it returns Restricted, then run `Set-ExecutionPolicy AllSigned` or `Set-ExecutionPolicy Bypass -Scope Process`.
4. Now run this command in powershell:

```bash
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

1. Wait a few seconds for the command to complete. If you don't see any errors, you are ready to use Chocolatey! Type `choco` or `choco -?`
