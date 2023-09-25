# GCP Secret Manager Buildkite Plugin

[![GitHub Release](https://img.shields.io/github/release/robert-fahey/gcp-secret-manager-buildkite-plugin.svg)](https://github.com/robert-fahey/gcp-secret-manager-buildkite-plugin/releases) [![Build status](https://badge.buildkite.com/2d6dda24352064bc947c7affb868734d615bafeecb22102007.svg?branch=master)]()

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) to read secrets from [GCP Secret Manager](https://cloud.google.com/secret-manager).

This plugin requires either a Google Cloud credentials file or application default credentials to be available on your Buildkite Agent machines. Additionally, you must specify the GCP project ID that the secrets will be pulled from.

Other preinstalled requirements:

- [`gcloud`](https://cloud.google.com/sdk/)
- [`jq`](https://stedolan.github.io/jq/)

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: 'echo \$SECRET_VAR'
    plugins:
      - robert-fahey/gcp-secret-manager#v1.1.0:
        project_id: "your-gcp-project-id" # NEW
        credentials_file: /etc/gcloud-credentials.json
        env:
        SECRET_VAR: my-secret-name
        OTHER_SECRET_VAR: my-other-secret-name`
```

## Configuration

### `project_id` (required, string)

The Google Cloud Project ID from which the secrets will be pulled.

### `credentials_file` (optional, string)

The file path of a Google Cloud [credentials file](https://developers.google.com/workspace/guides/create-credentials#create_credentials_for_a_service_account) which is used to access the secrets. If not specified, the [application default credential](https://cloud.google.com/docs/authentication/application-default-credentials) will be searched for and used if available. The account credential must have the Secret Accessor role for the secret being accessed (`roles/secretmanager.secretAccessor`).

### `env` (object)

An object defining the export variables names and the secret names which will populate the values.

## Developing

To run the tests:

```shell
docker-compose run --rm shellcheck
docker-compose run --rm tests
```

## Contributing

1.  Fork the repo
2.  Make the changes
3.  Run the tests
4.  Commit and push your changes
5.  Send a pull request

---

The main change here is the introduction of `project_id` as a required field in the example and the Configuration section. Adjust the example project name 'your-gcp-project-id' as needed based on your specific requirements.
