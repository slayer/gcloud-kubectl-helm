#!/bin/sh

cat <<EOF | envsubst | curl -s -X POST -H 'Content-type: application/json' -d@- ${SLACK_WEBHOOK_URL}
{
  "username": "${CI_PROJECT_NAME}-deployer",
  "attachments": [
    {
      "color": "good",
      "title": "${TITLE:-Deploy}",
      "fields": [
        {
          "title": "Pipeline",
          "value": "${CI_PROJECT_URL}/pipelines/${CI_PIPELINE_ID}",
          "short": false
        },
        {
          "title": "Job url",
          "value": "${CI_PROJECT_URL}/-/jobs/${CI_JOB_ID}",
          "short": false
        },
        {
          "title": "Job",
          "value": "${CI_JOB_NAME}",
          "short": true
        },
        {
          "title": "Branch",
          "value": "${CI_COMMIT_REF_NAME}",
          "short": true
        },
        {
          "title": "Commit",
          "value": "${CI_COMMIT_SHORT_SHA}",
          "short": true
        },
        {
          "title": "User",
          "value": "${GITLAB_USER_EMAIL}",
          "short": true
        }
      ],
      "fallback": "text"
    }
  ]
}
EOF

