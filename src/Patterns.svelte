<script>
  export const patterns = [
    { w: 3, h: 2 },
    { w: 2, h: 3 },
    { w: 3, h: 3 },
  ];

  const canFindPattern = (w, h) => {
    for (const pattern of patterns)
      if (pattern.w === w && pattern.h === h) return true;
    return false;
  };

  const togglePattern = (w, h) => {
    for (let i = 0; i < patterns.length; i++) {
      const pattern = patterns[i];
      if (pattern.w === w && pattern.h === h) {
        patterns.splice(i, 1);
        patterns = patterns;
        return;
      }
    }
    patterns.push({ w, h });
    patterns = patterns;
  };

  let max = 5;
</script>

<div>
  <table>
    <tr>
      {#each Array(max + 1) as _, w}
        <tr>
          {#each Array(max + 1) as _, h}
            <td>
              {#if w === 0}
                {h}
              {:else if h === 0}
                {w}
              {:else}
                <div
                  class={patterns && canFindPattern(w, h) ? "checkbox filled" : "checkbox"}
                  on:click={e => togglePattern(w, h)}
                />
              {/if}
            </td>
          {/each}
        </tr>
      {/each}
    </tr>
  </table>
</div>

<style>
  td {
    padding: 5px;
    text-align: center;
  }
  .checkbox {
    width: 20px;
    height: 20px;
    border: 2px solid black;
  }
  .filled {
    background-color: black;
  }
</style>
