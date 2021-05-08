<script>
  import Config from "./Config.svelte";
  import Patterns from "./Patterns.svelte";
  import Results from "./Results.svelte";
  import { findSlimeChunks } from "./slime";

  let patterns, radius, seed, results;

  let progress = 0;

  const foundPatternCallback = (x, z, w, h) => {
    results.push({ x, z, w, h });
    results = results;
  };

  const progressCallback = (percent) => {
    progress = percent;
    console.log(percent);
  };

  const handleClick = () => {
    results = [];
    progress = 0;
    findSlimeChunks(
      seed,
      radius,
      patterns,
      foundPatternCallback,
      progressCallback
    );
  };
</script>

<div class="outer">
  <div class="column">
    <div class="box">
      <Patterns bind:patterns />
    </div>
    <div class="box">
      <Config bind:seed bind:radius />
      <p>
        <button on:click={handleClick}>Find chunks</button>
        Progress: {progress}%
      </p>
    </div>
  </div>
  <div class="column">
    <div class="box">
      <Results bind:results />
    </div>
  </div>
</div>

<!-- Map -->
<style>
  .outer {
    margin: auto;
    max-width: 900px;
  }
  .box {
    border: 2px solid black;
    border-radius: 10px;
    padding: 10px;
    margin: 10px;
  }
  .column {
    float: left;
  }
  @media screen and (max-width: 680px) {
    .column {
      width: 100%;
    }
  }
</style>
