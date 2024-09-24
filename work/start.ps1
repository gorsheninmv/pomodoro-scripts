$headers = @{
  "Authorization" = "Bearer $env:MMTOKEN"
  "Content-Type" = "application/json"
}

$body = @{
  "user_id" = $env:MMUSERID
  "status" = "dnd"
} | ConvertTo-Json

$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest -Uri $env:MMURI -Headers $headers -Method PUT -Body $body | Out-Null
