# fish-ssh-agent Changelog

## 1.1.1 / 2021-06-03

- Fixed a bug with the detection of macOS.

## 1.1.0 / 2021-04-02

- Not all SSH keys include the filename when printed with `ssh-add -L`.
  Key discovery has been modified to compare identity bodies prior to
  considering identity filenames. This is slower but safer as it requires
  that we read the identity’s public file for comparison.

- Improved default `ssh-add` flags.

- Removed dependency on halostatue/fish-utils-core.

## 1.0.1 / 2020-10-27

- Fixed a typo

## 1.0 / 2020-10-10

- Initial version
