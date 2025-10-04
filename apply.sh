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

  # Plan
  tfvars_file="${env}.tfvars"
  echo "📄 Creating plan for $env..."
  terraform plan -var-file="$tfvars_file" -out=tfplan.out

  # Show plan
  echo "⚠️ Review the plan output for $env:"
  terraform show tfplan.out

  # Prompt before apply
  echo "🚀 Do you want to apply this plan to $env? (yes/no)"
  read choice

  if [ "$choice" == "yes" ]; then
      echo "✅ Applying changes to $env..."
      terraform apply "tfplan.out"

      echo "📊 Showing the current state after applying the plan..."
      terraform show
  else
      echo "❌ Deployment for $env cancelled."
  fi

  done
