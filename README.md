# Harmander Sahib Hukamnamas

Archive of Hukamnamas from Sachkhand Siri Harmander Sahib

An archive of the daily Hukamnama raw HTML from [SGPC.net]()

First ran on `2023-08-03` by Guru's grace.

Run on [daily basis](.github/workflows/save-hukamnama.yaml) using a [Github actions schedule](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)

## To be used for

- Bulk process a database of previous Hukamnamas
- Create an open, robust and cheap archive resource for the global sangat to use

## Tree

```bash
.
└── hukamnamas
    └── 2023 # raw SGPC hukamnama htmls stored here by year

```

---

## Requirements

- bash
- curl
- awk
- [htmlq](https://github.com/mgdm/htmlq) included here to do some validation
- shellcheck, yamllint using `github/super-linter`

## Running

```bash
./save.sh
```

[LICENCE](LICENCE)
