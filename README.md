
# Bouncing Dvd Logo - Written in Zig & Raylib

a simple application that is mostly a way for me to learn zig and a way for me to show my programming knowladge and abilites


![Logo](https://i.ibb.co/q7ZRYXC/dvd-logo-icon.png)


## Related

Here are some of my other projects

[WebServerC](https://github.com/PanasMoti/WebServerC)

[bee-script](https://github.com/PanasMoti/bee-script)


## Run Locally

Clone the project

```bash
  git clone https://github.com/PanasMoti/DvD-Logo-Zig
```

Go to the project directory

```bash
  cd DvD-Logo-Zig
```

Install dependencies:

* [raylib](https://github.com/raysan5/raylib?tab=readme-ov-file#installing-and-building-raylib-on-multiple-platforms)
* [zig](https://ziglang.org/learn/getting-started/)


Add executation permission to the build script
```bash
  chmod +x build.sh
```

Run the build script
```bash
  ./build.sh
```

Start the application

```bash
  ./dvdlogo
```


## Lessons Learned

Zig is both a rewarding langauge and punishing at times
while similar to C and capable of linking with C libraries , Zig is kind of harsh when it comes to stuff like *type conversion* and it feels at times incomplete like having to do both @as and @floatFromInt like:
```zig
    @as(f32, @floatFromInt(value))
```
it cant be quite tough coming from C where i can pretty much count on the compiler to do the converting or at the very least do it as
```c
    (float)iValue
```
but i had a blast making this project and learned a lot about Zig and i might use it for more projects in the future

