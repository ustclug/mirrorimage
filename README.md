# mirrorimage

The fast way to use USTC mirrors in your container.

## Available distros

`ustclug/ubuntu`, `ustclug/debian`, `ustclug/fedora`, `ustclug/centos`, `ustclug/alpine`.

## Example

Just add `ustclug/` before the distro official image you are using. For example:

```
sudo docker run -it --rm debian:11
```

Could be replaced by:

```
sudo docker run -it --rm ustclug/debian:11
```
