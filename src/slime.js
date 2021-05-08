/*
 * Callbacks:
 * extern void foundPatternCallback(long x, long z, int w, int h);
 * extern void progressCallback(int percent);
 */
export async function findSlimeChunks(
  seed,
  radius,
  patterns,
  foundPatternCallback,
  progressCallback
) {
  seed = BigInt(seed);
  radius = Math.floor(radius);

  const importObject = {
    env: { foundPatternCallback, progressCallback },
  };

  const { instance } = await WebAssembly.instantiateStreaming(
    fetch("wasm.wasm"),
    importObject
  );

  console.log(instance);

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

  // Find chunks
  for (const _ of Array(101)) {
    setTimeout(
      async () => instance.exports.findSlimeChunks(seed, radius),
      1
    );
  }
}
