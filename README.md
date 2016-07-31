# _xzy_kl

__Development version__

Based on the work of [DoubleDensity's Tidebox](https://github.com/DoubleDensity/tidebox) and
[tida1vm by @lvm](https://github.com/lvm/tida1vm)

> A complete Tidalesque musical live coding and audio streaming environment inside Docker

uses latest development version of Tidal.

## Getting started

You can use `docker pull` to get a recent built image for tidal.

```bash
$ docker pull lennart/tida1vm:0.9-dev

__Beware this build might not be up to date with current state of git branch `0.9-dev` of tidal.__
```

If you want extra control you follow the instructions below to customize the default tidal image.

### Build from source

```bash  
$ git clone https://github.com/lennart/tida1vm
$ cd xzykl
$ git checkout 0.9-dev
$ docker build -t tida1vm:0.9-dev .
$ docker run -ti --rm --privileged --name xzykl xzykl:0.9-dev
```

## References

- [tida1vm](https://github.com/lvm/tida1vm)
- [Tidebox](https://github.com/DoubleDensity/tidebox)
- [Tidal](http://tidal.lurk.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [tmux](https://tmux.github.io/)
- [GM Level 1 Sound Set](https://www.midi.org/specifications/item/gm-level-1-sound-set)
- [GeneralUser SoundFont](http://www.schristiancollins.com/generaluser.php)
- [TOPLAP The Home of Live Coding](http://toplap.org/)
