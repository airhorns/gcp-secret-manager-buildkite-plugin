#!/usr/bin/env bats

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"
}

environment_hook="$PWD/hooks/environment"

@test "Fetches values from GCP Secret Manager into env with specified version" {
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_CREDENTIALS_FILE="/tmp/credentials.json"
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_ENV_TARGET1="secret1:5"
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_PROJECT_ID="test-project"

  stub which \
    "gcloud : echo /test/gcloud" \
    "jq : echo /test/jq"

  stub gcloud \
    "auth activate-service-account --key-file /tmp/credentials.json : echo OK" \
    "secrets versions access 5 --project=test-project --secret=secret1 '--format=get(payload.data)' : echo 'dGVzdC12YWx1ZTEK'"

  run "${environment_hook}"

  assert_success
  assert_output --partial "Exporting secret secret1 from GCP Secret Manager into environment variable TARGET1"

  unstub gcloud
  unstub which

  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_CREDENTIALS_FILE
  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_ENV_TARGET1
  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_PROJECT_ID
}

@test "Fetches values from GCP Secret Manager into env without specifying version" {
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_CREDENTIALS_FILE="/tmp/credentials.json"
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_ENV_TARGET1="secret1"
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_PROJECT_ID="test-project"

  stub which \
    "gcloud : echo /test/gcloud" \
    "jq : echo /test/jq"

  stub gcloud \
    "auth activate-service-account --key-file /tmp/credentials.json : echo OK" \
    "secrets versions list secret1 --project=test-project --format=json : echo '[{\"name\":\"secret1/versions/10\"}]'" \
    "secrets versions access 10 --project=test-project --secret=secret1 '--format=get(payload.data)' : echo 'dGVzdC12YWx1ZTEK'"

  run "${environment_hook}"

  assert_success
  assert_output --partial "Exporting secret secret1 from GCP Secret Manager into environment variable TARGET1"

  unstub gcloud
  unstub which

  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_CREDENTIALS_FILE
  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_ENV_TARGET1
  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_PROJECT_ID
}

@test "Fetches values from GCP Secret Manager into env via Application Default Credentials" {
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_ENV_TARGET1="secret1"
  export BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_PROJECT_ID="test-project"

  stub which \
    "gcloud : echo /test/gcloud" \
    "jq : echo /test/jq"

  stub gcloud \
    "secrets versions list secret1 --project=test-project --format=json : echo '[{\"name\":\"secret1/versions/10\"}]'" \
    "secrets versions access 10 --project=test-project --secret=secret1 '--format=get(payload.data)' : echo 'dGVzdC12YWx1ZTEK'"

  run "${environment_hook}"

  assert_success
  assert_output --partial "Exporting secret secret1 from GCP Secret Manager into environment variable TARGET1"

  unstub gcloud
  unstub which

  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_ENV_TARGET1
  unset BUILDKITE_PLUGIN_GCP_SECRET_MANAGER_PROJECT_ID
}
