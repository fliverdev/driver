<p align="center"><img height="125px" width="125px" src="./branding/rickshaw.png" alt="Fliver Driver"/><img height="125px" width="400" src="./branding/text-black.png" alt="Fliver Driver"/></p>

# Fliver Driver for iOS & Android

[![Stars](https://img.shields.io/github/stars/fliverdev/driver.svg)](https://github.com/fliverdev/driver/stargazers)
[![Forks](https://img.shields.io/github/forks/fliverdev/driver.svg)](https://github.com/fliverdev/driver/network/members)
[![Issues](https://img.shields.io/github/issues/fliverdev/driver.svg)](https://github.com/fliverdev/driver/issues)
[![License](https://img.shields.io/github/license/fliverdev/driver.svg)](https://opensource.org/licenses/GPL-3.0)

Fliver is a smartphone app to help ease the process of getting a taxi. When you need one, simply open the app and swipe the button - that's it. If there are 3 or more Riders within the same area, Drivers will be notified and can come to your spot to pick you up. It's that simple!

This is the Driver app repository for Drivers to view the areas of Rider demand. It is part of the Final Year Project of a bunch of Computer Engineering students.

## Building

**Important:** this project contains certain files that are encrypted due to the use of API keys, which is why it will not build directly on your machine. Please refer to [ENCRYPTION.md](ENCRYPTION.md) for more information.

To build and run the app on your device, do the following:

-   Install Flutter by following the instructions on their [website](https://flutter.dev/docs/get-started/install/).
-   Clone this repo to your local machine using `git clone https://github.com/fliverdev/driver.git`.
-   Replace all the encrypted files with your own as explained in [ENCRYPTION.md](ENCRYPTION.md).
-   Connect your devices/emulators and run the app using `flutter run` in the root of the project directory.

**Note:** you can also run it in release mode using `flutter run --release` to improve performance and stability, however, debugging features will be disabled.

## Contributing

Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for more details on how to contribute.

## Credits

This project is primarily developed by a bunch of Computer Engineering students at NMIMS's MPSTME:

-   [Urmil Shroff](https://github.com/urmilshroff)
-   [Priyansh Ramnani](https://github.com/prince1998)
-   [Vinay Kolwankar](https://github.com/vinay-ai)

Take a look at the entire list of [contributors](https://github.com/fliverdev/driver/graphs/contributors) to see who all have helped with the project via pull requests.

## License

This project is licensed under the GNU GPL v3 - see the [LICENSE](LICENSE) file for details.
