module wasm;

import std.algorithm : map, maxElement;
import std.conv : to;

extern (C):

/*
 * Js imports
 */
extern ubyte __heap_base;
extern void foundPatternCallback(long x, long z, int w, int h);
extern void progressCallback(double percent);

/*
 * Core functions
 */
void* bump_pointer;
void* malloc(size_t n)
{
  if (bump_pointer == null)
    bump_pointer = &__heap_base;
  auto block = bump_pointer;
  bump_pointer += n;
  return block;
}

T abs(T)(T a)
{
  return a < 0 ? -a : a;
}

void __assert(const(char)* exp, const(char)* file, uint line)
{
}

/*
 * Application
 */
struct Pattern
{
  int w, h;
}

Pattern[] patterns;

void createPatternArray(size_t length)
{
  Pattern* ptr = cast(Pattern*) malloc(Pattern.sizeof * length);
  patterns = ptr[0 .. length];
}

void setPattern(int index, int width, int height)
{
  patterns[index] = Pattern(width, height);
}

int findMaxHeight()
{
  if (patterns !is null)
    return patterns.map!(a => a.h).maxElement;
  else
    return 0;
}

struct RestorePoint
{
  bool active = false;
  int z;
}

RestorePoint restorePoint;

bool* arr;

void findSlimeChunks(const long seed, const int radius, const int runLength)
{
  immutable int size = radius * 2;
  immutable int maxHeight = findMaxHeight();

  if (maxHeight < 1 || radius < 1)
    return;

  // Grid of radius*2 x max pattern height
  // Only maxHeight rows are necessary at once
  if (!restorePoint.active)
    arr = cast(bool*) malloc(size * maxHeight);

  int chunksProcessed;
  foreach (ref int z; -radius .. radius + maxHeight)
  {
    if (restorePoint.active)
    {
      z = restorePoint.z + 1;
      restorePoint.active = false;
    }

    if (chunksProcessed >= runLength)
    {
      progressCallback((z + radius).to!double / (size / 100));
      restorePoint.z = z;
      restorePoint.active = true;
      return;
    }

    // Fill a row of values
    if (z < radius)
      foreach (x; -radius .. radius)
        arr[(x + radius) + ((z + radius) % maxHeight) * size] = isSlimeChunk(seed, x, z);

    // Check if enitre grid has been filled
    if (z + radius >= maxHeight - 1)
    {
      // Check for patterns
      immutable int patternZ = z - (maxHeight - 1);
      foreach (pattern; patterns)
        if (patternZ + radius + pattern.h < size)
          foreach (x; -radius .. radius - pattern.w)
            if (checkGrid(arr, maxHeight, radius, size, x, patternZ, pattern.w, pattern.h))
              foundPatternCallback(x * 16, patternZ * 16, pattern.w, pattern.h);
    }
    chunksProcessed += size;
  }
  progressCallback(100);
}

pure bool checkGrid(bool* arr, int maxHeight, long radius, long size, long x,
    long z, int width, int height)
{
  foreach (x2; 0 .. width)
    foreach (z2; 0 .. height)
      if (!arr[cast(uint)((x + x2 + radius) + ((z + z2 + radius) % maxHeight) * size)])
        return false;
  return true;
}

pure bool isSlimeChunk(long seed, long x, long z)
{
  // Minecraft code:
  // Do not write += here
  seed = seed + cast(int)(x * x * 0x4c1906) + cast(int)(x * 0x5ac0db);
  seed = seed + cast(int)(z * z) * 0x4307a7L + cast(int)(z * 0x5f24f) ^ 0x3ad8025f;

  // java.util.random code:
  seed = (seed ^ 0x5DEECE66DL) & ((1L << 48) - 1);
  int bits, val;
  do
  {
    seed = (seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
    bits = cast(int)(seed >>> (48 - 31));
    val = bits % 10;
  }
  while (bits - val + (10 - 1) < 0);
  return val == 0;
}
