# Imaginarium

This repository contains various common reusable docker images, that are opinionated as per the `amredev` developers.

## Development

We use [Buildx Bake](https://docs.docker.com/build/bake/) to define the docker build. Run the following command to build an image and run a container from it for testing.

```bash
./scripts/test.sh {bake_target}
```

## License

<sup>
Licensed under either of <a href="https://github.com/elastio/bon/blob/master/LICENSE-APACHE">Apache License, Version
2.0</a> or <a href="https://github.com/elastio/bon/blob/master/LICENSE-MIT">MIT license</a> at your option.
</sup>

<br>

<sub>
Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.
</sub>
