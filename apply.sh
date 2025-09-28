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
