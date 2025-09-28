#!/bin/bash

envs=("prod" "staging" "qa")

for env in "${envs[@]}"; do
  echo "📦 Switching to $env environment directory..."
  cd "./environment/$env" || exit 1

  # Terraform init
  echo "🔍 Initializing Terraform..."
  terraform init -reconfigure

  # Validate & fmt
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
      terraform destroy -var-file="$tfvars_file" -auto-approve

      # Inform about KMS behavior
      echo "🔒 KMS keys will be disabled and scheduled for deletion (10 days)."

      echo "📊 Showing the state after destroy..."
      terraform show
  else
      echo "❌ Destroy for $env cancelled."
  fi

  # Go back to root
  cd ../../
done
