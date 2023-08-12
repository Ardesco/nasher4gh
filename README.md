# Nasher For Github Actions

Github action to run nwn module builds using Nasher as a github action

## Run nasher4gh

This action is a GH compatible wrapper for nasher (https://github.com/squattingmonk/nasher).

Basic usage to just build your module is as below (**This will use the NWNSC compiler**):

```yaml
name: Run CI Build

on:
  push:
    branches:
      - master

jobs:
  ci_build:
    runs-on: ubuntu-latest
    name: NWN:EE CI Build
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build module
        uses: Ardesco/nasher4gh@v1
```
This will run `nasher pack --default`

If you want to use the new nwn_script_comp compiler you will need to pass in an additional argument called `-usenwnscriptcomp`:

```yaml
name: Run CI Build

on:
  push:
    branches:
      - master

jobs:
  ci_build:
    runs-on: ubuntu-latest
    name: NWN:EE CI Build
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build module
        uses: Ardesco/nasher4gh@v1
        with:
          args: "['pack', '--default', '-usenwnscriptcomp']"
```

As you can see above the commands you pass into the container are configurable, you can pass in any options supported by nasher (see https://github.com/squattingmonk/nasher#commands).  

```yaml
name: Run CI Build

on:
  push:
    branches:
      - master

jobs:
  ci_build:
    runs-on: ubuntu-latest
    name: NWN:EE CI Build
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build module
        uses: Ardesco/nasher4gh@v1
        with:
          args: "['compile', '--no', '--verbose']"
```
You can also modify/override default config options if you use the -option flag as shown below:

```yaml
name: Run CI Build

on:
  push:
    branches:
      - master

jobs:
  ci_build:
    runs-on: ubuntu-latest
    name: NWN:EE CI Build
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build module
        uses: Ardesco/nasher4gh@v1
        with:
          args: "['pack', '--default', '-option', '--userName:\"Ardesco\"']"
```

## Docker container source 

Docker containers used by this action are created/managed via https://github.com/Ardesco/nasher4gh-images.

## License
The Dockerfile and associated scripts and documentation in this project are released under the [Apache-2.0 License](LICENSE).