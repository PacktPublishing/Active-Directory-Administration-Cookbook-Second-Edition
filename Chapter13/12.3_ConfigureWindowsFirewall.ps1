New-NetFirewallRule -Name Allow_HTTP -DisplayName �AD FS HTTP Services� -Protocol TCP -LocalPort 80 -Profile Any -Action Allow