# mirrorimage

The fast way to use USTC mirrors in your container.

## Available distros

`ustclug/ubuntu`, `ustclug/debian`, `ustclug/fedora`, ~~`ustclug/centos`~~, `ustclug/rocky`, `ustclug/alpine`.

Also published on GHCR: Just prepend `ghcr.io/ustclug/` before the image name.

## Example

Just add `ustclug/` before the distro official image you are using. For example:

```shell
sudo docker run -it --rm debian:12
```

Could be replaced by:

```shell
sudo docker run -it --rm ustclug/debian:12
# or
sudo docker run -it --rm ghcr.io/ustclug/debian:12
```
