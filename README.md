About
-----

This is a fork of [arm-neon-vfp-test](https://github.com/jzawodn/arm-neon-vfp-test).
The test itself was fixed not to do several unaccounted floating point operations.
`Makefile` was replaced with `build.pl` and `runall.sh` to ease extensive trial of various compilation options and to allow cross-compilation of test programs.

For more information and performance evaluation of several boards see [arm-neon-vfp-test](https://github.com/jzawodn/arm-neon-vfp-test).

Compilation
-----

On build machine (it may be an embedded board as well but you need perl there) modify `build.pl` to include all dimensions of compilation options you want to search.
Then, run `./build.pl`.

```
arm-gentoo-linux-gnueabi-gcc -O2 test.c -std=gnu99 -static -o arm-gentoo-none-none-none-2-test.out
arm-gentoo-linux-gnueabi-gcc -O3 test.c -std=gnu99 -static -o arm-gentoo-none-none-none-3-test.out
...
armv5te-hardfloat-linux-gnueabi-gcc -mfloat-abi=hard -mfpu=vfpv3-d16 -march=armv5te -O2 test.c -std=gnu99 -static -o armv5te-hardfloat-hard-vfpv3-d16-armv5te-2-test.out
armv5te-hardfloat-linux-gnueabi-gcc -mfloat-abi=hard -mfpu=vfpv3-d16 -march=armv5te -O3 test.c -std=gnu99 -static -o armv5te-hardfloat-hard-vfpv3-d16-armv5te-3-test.out
```

Run
---

Copy runall.sh and all compiled programs (`*.out`) to the board you want to run them on.
Put them into a single directory.
Optionally, modify `runall.sh` to tweak arguments to programs.
Run `./runall.sh`.
