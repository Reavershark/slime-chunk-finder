<script>
  export let seed = 0;
  export let radius = 1000;
</script>

<div>
  <table>
    <tr>
      <td><p>World seed:</p></td>
      <td><input type="number" bind:value={seed} /></td>
    </tr>
    <tr>
      <td><p>Search radius:</p></td>
      <td><input type="number" bind:value={radius} min="0" /></td>
    </tr>
  </table>
</div>

<style>
  td {
    padding-right: 1em;
  }
</style>