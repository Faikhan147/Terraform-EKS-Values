#!/bin/bash

# Save root directory
ROOT_DIR=$(pwd)

envs=("prod" "staging" "qa")

for env in "${envs[@]}"; do
  ENV_DIR="$ROOT_DIR/environment/$env"

  if [ ! -d "$ENV_DIR" ]; then
    echo "❌ Environment directory $ENV_DIR does not exist. Skipping $env."
    continue
  fi

  echo "📦 Switching to $env environment directory..."
  cd "$ENV_DIR" || exit 1


  # Terraform init
  echo "🔍 Initializing Terraform..."
  terraform init -reconfigure

  # Terraform Validate
  echo "✅ Validating configuration..."
  terraform validate
  
  echo "📝 Formatting Terraform files..."
  terraform fmt -recursive

  # Workspace list
  echo "🔢 Listing available workspaces..."
  terraform workspace list

  # Prompt before destroy
echo "⚠️ Are you sure you want to destroy all resources in $env? (yes/no)"
read choice

if [ "$choice" == "yes" ]; then
  tfvars_file="${env}.tfvars"
  echo "💣 Destroying resources in $env using $tfvars_file..."
  # run destroy and capture output
  destroy_output=$(terraform destroy -var-file="$tfvars_file" -auto-approve 2>&1)

  echo "$destroy_output"

  # only show KMS message if something was actually destroyed
  if echo "$destroy_output" | grep -q "Destroy complete! Resources: [1-9]"; then
    echo "🔒 KMS keys will be disabled and scheduled for deletion (10 days)."
  fi

  echo "📊 Showing the state after destroy..."
  terraform show
else
  echo "❌ Destroy for $env cancelled."
fi

done   
