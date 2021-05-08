<script>
  import Config from "./Config.svelte";
  import Patterns from "./Patterns.svelte";
  import Results from "./Results.svelte";
  import { slimeFinder } from "./slime";

  let seed, radius, patterns;

  slimeFinder.onUpdate = () => (slimeFinder = slimeFinder);

  const handleStart = () => slimeFinder.findSlimeChunks(seed, radius, patterns);
  const handleStop = () => slimeFinder.break();
</script>

<div class="outer">
  <div class="column">
    <div class="box">
      <Patterns bind:patterns />
    </div>
    <div class="box">
      <Config bind:seed bind:radius />
      <p>
        <button disabled={slimeFinder.busy} on:click={handleStart}
          >Find chunks</button
        >
        Progress: {slimeFinder.progress}%
      </p>
      <p>
        <button disabled={!slimeFinder.busy} on:click={handleStop}>Stop</button>
      </p>
    </div>
  </div>
  <div class="column">
    <div class="box">
      <Results bind:results={slimeFinder.results} />
    </div>
  </div>
</div>

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
