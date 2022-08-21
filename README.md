# Android Rom Builder 🛠

Did you ever have the urge to build/compile a (Custom) Android ROM but —
- A) You didn't want to litter your clean minimal Linux install or
- B) Didn't use a Debian-Based distribution or
- C) Use a proprietary OS such as Windows or
- D) Would like to focus on building the ROM instead of the environment or
- E) All of the above or
- F) None of the above

you came to the right place.

`2tefan/android-rom-builder` is a small Docker Image, which includes all common tools to download and build a Custom Android ROM such as [LineageOS](https://github.com/LineageOS), [Resurrection Remix](https://github.com/ResurrectionRemix) or [crDroid](https://github.com/crdroidandroid) to just name a few.

## Usage 🚀

> Enough chitchat, how does this bloody thing work?

First of all as this is a Docker Image, make sure you have installed [Docker](https://docs.docker.com/get-docker/) first.

Then make sure you find a directory in which all the Android source files will be downloaded to. Don't worry, you can change it later on, but keep in mind that the sources are up to 200 GB big. Another thing to take into consideration is the type of storage medium. A fast SSD will lead to faster build times than a old and rusty HDD. (It is also possible to use [Docker Volumes](https://docs.docker.com/storage/volumes/) if you want to.)

If you have made up your mind, all that is left do to is to start up the Docker container:
```sh
docker run -v $(pwd):/root/project -it 2tefan/android-rom-builder:stable-ubuntu-20.04
```

