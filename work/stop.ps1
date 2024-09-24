function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        [parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "Pomodoro"
    $Toast.Group = "Pomodoro"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Pomodoro")
    $Notifier.Show($Toast);
}

Show-Notification "Pomodoro session finished" ""

$headers = @{
  "Authorization" = "Bearer $env:MMTOKEN"
  "Content-Type" = "application/json"
}

$body = @{
  "user_id" = $env:MMUSERID
  "status" = "online"
} | ConvertTo-Json

$ProgressPreference = "SilentlyContinue"
Invoke-WebRequest -Uri $env:MMURI -Headers $headers -Method PUT -Body $body | Out-Null
