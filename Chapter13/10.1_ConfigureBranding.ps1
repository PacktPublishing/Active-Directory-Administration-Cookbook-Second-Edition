Set-AdfsGlobalAuthenticationPolicy -EnablePaginatedAuthenticationPages $true
Set-AdfsProperties –EnableIdpInitiatedSignonPage $True
New-AdfsWebTheme –Name custom -SourceName default
Set-AdfsWebTheme -TargetName custom -Logo @{path="C:\Style\logo.png"}
Set-AdfsWebTheme -TargetName custom –Illustration @{path="C:\Style\background.jpg"}
Set-AdfsGlobalWebContent –SignInPageDescriptionText "<p>By logging on, you gain access to services. When using these services, rules apply as stated in the protocol. Unauthorized access is prohibited.</p>"
Set-AdfsWebConfig -ActiveThemeName custom
Set-AdfsProperties –EnableIdpInitiatedSignonPage $False