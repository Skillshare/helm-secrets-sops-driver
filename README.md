# Sops Driver for Helm Secrets

Includes a driver for skipping hard-coded AWS assume role when using
KMS. This is a workaround for when some accesses require assuming
roles and other's do not (i.e. accessing KMS via an AWS instance
profile).

## Usage

Prepend all calls with `secrets-sops-driver`. This exports
`SECRETS_DRIVER` read by the `secrets` plugin.

Set `SOPS_SKIP_KMS_ASSUME_ROLE` to `1` or `true` to enable the
feature.

```
$ helm secrets-sops-driver secrets template ...
$ helm secrets-sops-driver secrets template ...
```
