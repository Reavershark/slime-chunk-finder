// extern void foundPatternCallback(long x, long z, int w, int h);
const foundPatternCallback = (x, z, w, h) => {
  slimeFinder.results.push({ x, z, w, h });
  slimeFinder.results = slimeFinder.results;
};

// extern void progressCallback(double percent);
const progressCallback = (progress) => {
  slimeFinder.progress = progress;
  slimeFinder = slimeFinder;
};

class SlimeFinder {
  constructor() {
    this.progress = 0;
    this.results = [];
    this.busy = false;
    this.interval = 0;
    this.onUpdate = () => {};
  }

  break() {
    this.busy = false;
  }

  async findSlimeChunks(seed, radius, patterns) {
    this.progress = 0;
    this.results = [];

    seed = BigInt(seed);
    radius = Math.floor(radius);

    if (radius < 1)
      return;

    this.busy = true;

    const importObject = {
      env: {
        foundPatternCallback,
        progressCallback,
      },
    };

    const { instance } = await WebAssembly.instantiateStreaming(
      fetch("wasm.wasm"),
      importObject
    );

    // console.log(instance);

    // Make space for patterns
    instance.exports.memory.grow(1 + (patterns.length * 2 * 4) / (64 * 1024));

    // Transfer patterns array
    instance.exports.createPatternArray(patterns.length);
    for (let i = 0; i < patterns.length; i++) {
      let w = Math.floor(patterns[i].w);
      let h = Math.floor(patterns[i].h);
      instance.exports.setPattern(i, w, h);
    }

    // Make space for chunks array
    let maxHeight = instance.exports.findMaxHeight();
    instance.exports.memory.grow(1 + (radius * 2 * maxHeight) / (64 * 1024));

    this.interval = setInterval(async () => {
      if (this.busy && this.progress < 100) {
        instance.exports.findSlimeChunks(seed, radius, 100_000);
      } else {
        clearInterval(this.interval);
        this.busy = false;
      }
      this.onUpdate();
    }, 0);
  }
}

export let slimeFinder = new SlimeFinder();