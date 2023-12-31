# Harmander Sahib Hukamnamas

[![linting](https://github.com/sikhnet/harmander-sahib-hukamnamas/actions/workflows/lint.yaml/badge.svg)](https://github.com/sikhnet/harmander-sahib-hukamnamas/actions/workflows/lint.yaml)
[![save-hukamnama](https://github.com/sikhnet/harmander-sahib-hukamnamas/actions/workflows/save-hukamnama.yaml/badge.svg)](https://github.com/sikhnet/harmander-sahib-hukamnamas/actions/workflows/save-hukamnama.yaml)

![Dall-e: harmandir sahib, 8 bit pixel style](icon.png)

Archive of Hukamnamas from [Sachkhand Siri Harmander Sahib](https://en.wikipedia.org/wiki/Golden_Temple)

An archive of the daily Hukamnama raw HTML from [SGPC.net](http://SGPC.net)

First ran on `2023-08-03` by Guru's grace

Runs on a [daily basis](.github/workflows/save-hukamnama.yaml) using a [Github actions schedule](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)

## To be used for

- Bulk process previous Hukamnamas to feed various targets
- Create an open, robust and cheap archive resource for the global sangat to use and for future generations

## Tree

```bash
.
└── hukamnamas
    └── raw
        └── 2023 # raw html SGPC hukamnama stored here by year
```

---

## Requirements

- bash
- curl
- awk
- grep
- [curl browser impersonation scripts](https://github.com/lwthiker/curl-impersonate/)
- shellcheck, yamllint using `github/super-linter`

## Running

```bash
./save.sh
```

## Licence

[LICENCE](LICENCE)
