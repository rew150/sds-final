Write-Host "Powershell mode";

$originalRegion = $env:AWS_DEFAULT_REGION;
$env:AWS_DEFAULT_REGION = '${region}';

aws ec2 wait instance-status-ok --instance-ids ${instance_id};

$commandId = aws ssm send-command --document-name ${ssm_doc_name} --instance-ids ${instance_id} --output text --query "Command.CommandId";

function waitForSSM() {
  while ($True) {
    $outputText = aws ssm wait command-executed --command-id $commandId --instance-id ${instance_id} 2>&1;
    Write-Host $outputText;
    if ($outputText -like "*Max attempts exceeded*") {
      Write-Host "Max attempts exceeded, restart waiting session...";
    } else {
      break;
    }
  }
  $success = $LASTEXITCODE -eq 0;
  Write-Host "waitForSSM success: $success";
  return $success;
}

if (!(waitForSSM)) {
  Write-Error 'Failed to start services on instance ${instance_id}!';
  Write-Error 'stdout:';
  Write-Error (aws ssm get-command-invocation --command-id $commandId --instance-id ${instance_id} --query StandardOutputContent);
  Write-Error 'stderr:';
  Write-Error (aws ssm get-command-invocation --command-id $commandId --instance-id ${instance_id} --query StandardErrorContent);

  $env:AWS_DEFAULT_REGION = $originalRegion;
  exit 1;
}

Write-Host 'Services started successfully on the new instance with id ${instance_id}!';
$env:AWS_DEFAULT_REGION = $originalRegion;
