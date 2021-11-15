#!/bin/bash
# fail the pipeline if fail only once
set -euxo pipefail

export AWS_DEFAULT_REGION=${region}

wait_for_ssm () {
  while aws ssm wait command-executed --command-id $command_id --instance-id ${instance_id} ; ret=$? ; [ $ret -eq 255 ] ; do
    echo "Wait command return 255, restart waiting session..."
  done
  return $ret
}

aws ec2 wait instance-status-ok --instance-ids ${instance_id}

command_id=$(aws ssm send-command --document-name ${ssm_doc_name} --instance-ids ${instance_id} --output text --query "Command.CommandId")
if ! wait_for_ssm ; then
  echo "Failed to start services on instance ${instance_id}!";
  echo "stdout:";
  aws ssm get-command-invocation --command-id $command_id --instance-id ${instance_id} --query StandardOutputContent;
  echo "stderr:";
  aws ssm get-command-invocation --command-id $command_id --instance-id ${instance_id} --query StandardErrorContent;
  exit 1;
fi;
echo "Services started successfully on the new instance with id ${instance_id}!"
