#!/bin/bash

DIAGRAM_FOLDER="diagrams"
DIAGRAM_NAME="main.png"
MAIN_PIPELINE_FILE="deploy-infra.yml"
PRIVATE_REPOSITORY_OWNER="leticiavalladares"
REPOSITORY_NAME="iac-iast-owasp-demo"
PROJECT_DESC="IaC for IAST of OWASP Juice Shop app."
PROJECT_TITLE="IAST demo using OpenTelemetry"
TERRAFORM_DEPLOY_FOLDER="infrastructure"
TERRAFORM_DEPLOY_PATH="infrastructure"
CLOUD_PROVIDER="AWS"
LAST_COMMIT=$(git log --pretty="%h - %s<br>" -n5 )
#MODULE_LIST=$(for i in $(ls -d modules/*); do echo "${i#*dules/}<br>"; done)

declare -a commits=($LAST_COMMIT)
LAST_COMMIT_MSG=$(git rev-list --format=%B --max-count=1 ${commits[0]})

if [ ! -f /README.md ]; then
    touch README.md
    printf "[![Terraform deployment for IAST OWASP demo](https://github.com/$PRIVATE_REPOSITORY_OWNER/$REPOSITORY_NAME/actions/workflows/$MAIN_PIPELINE_FILE/badge.svg)]\
(https://github.com/$PRIVATE_REPOSITORY_OWNER/$REPOSITORY_NAME/actions/workflows/$MAIN_PIPELINE_FILE) \
\n# $PROJECT_TITLE
\n## Description \
\n$PROJECT_DESC \
\n## Architecture \
\n![Architecture](./$DIAGRAM_FOLDER/$DIAGRAM_NAME) \
\n## Local deployment \
\n### Requirements \
\n- $CLOUD_PROVIDER CLI \
\n- Git \
\n- Terraform \
\n### Resources created on the AWS Management Console \
\n- tfstate S3 bucket with DynamoDB  \
\n- Secrets in AWS Secrets Manager to store database user and password \
\n-  \
\n### Requirements before deploying locally \
\n- Add local machine IP address as a variable in your environement  \
\n### Requirements before deploying through GitHub Actions \
\n- Add local machine IP address as a GitHub Secret in your repository \
\n### Steps for Unix systems \n \
1. Connect to your AWS account with short-term credentials from AWS IAM<br>\
\n \`aws configure\` \n \
\n\`\`\`
AWS Access Key ID [None]: <YOUR_ACCESS_KEY>
AWS Secret Access Key [None]: <YOUR_SECRET_ACCESS_KEY>
Default region name [None]: <REGION>
Default output format [None]: <PREFERRED_FORMAT_SUCH_AS_JSON>
\`\`\` \n \
\n 2. Clone this repository in your local machine <br>\
\n \`git clone <HTTPS/SSH>\` \n \
\n 3. Go to the repository folder <br>\
\n \`cd $REPOSITORY_NAME\` \n \
\n 4. Go to $TERRAFORM_DEPLOY_FOLDER folder <br>\
\n \`cd $TERRAFORM_DEPLOY_FOLDER\` \n \
\n 5. Initialize terraform <br>\
\n \`terraform init\` \n \
\n 6. Run terraform plan <br>\
\n \`terraform plan\` \n \
\n 7. Deploy resources in $CLOUD_PROVIDER <br>\
\n \`terraform apply\` \n" > README.md
fi

cd $TERRAFORM_DEPLOY_PATH
terraform-docs markdown ./ --output-file ../README.md

cd ../

if grep "## Five last commits" README.md; then
    printf "\\n whoa" >> README.md
    for i in "${commits[@]}" ; do
        echo "$i<br>" >> README.md
    done
    echo "$LAST_COMMIT" >> README.md
else
    echo "\n## Five last commits" >> README.md
    echo "$LAST_COMMIT" >> README.md
fi

printf "\
\n\
## README Activity Log\n\
This README file was updated on $(date) by $(git config user.name) \
on this [commit](https://github.com/$PRIVATE_REPOSITORY_OWNER/$REPOSITORY_NAME/commit/$(git rev-parse HEAD))
" >> ./README.md

sed -i -e 's/## /### /g' ./README.md