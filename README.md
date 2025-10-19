# SlideGen
SlideGen is a command line tool which generates a template project for [SlideKit](https://github.com/mtj0928/SlideKit).

## Usage
Run `slidegen` with the name of the presentation project you want to create.

```sh
slidegen MyPresentation           # defaults to a macOS SlideKit project
slidegen MyPresentation --platform iOS
```

SlideGen creates a new directory named after the product (for example `MyPresentation/`) that already contains the Xcode project, SlideKit sample slide, and required configuration files.
If the directory already exists, SlideGen stops without overwriting the contents.

The `--platform` option accepts `macOS` (default) and `iOS` and adjusts the generated files for that target platform.

## Installation
### Build from source
Clone this repository and build the executable with Swift Package Manager.

```sh
git clone https://github.com/mtj0928/SlideGen.git
cd SlideGen
swift build -c release
```

You can then run SlideGen with the release binary.

```sh
.build/release/slidegen SamplePresentations --platform macOS
```

The `--platform` option accepts `macOS` (default) and `iOS`.

### Using nest
SlideGen can also be installed via [nest](https://github.com/mtj0928/nest). Ensure that `~/.nest/bin` is in your `PATH`.

```sh
nest install mtj0928/SlideGen
slidegen SamplePresentations --platform macOS
```

### Using Mint
SlideGen is available through [Mint](https://github.com/yonaskolb/Mint) too.

```sh
mint run mtj0928/SlideGen SamplePresentations --platform macOS
```
