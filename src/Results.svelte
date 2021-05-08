<script>
  export let results = [];
</script>

<div>
  <table>
    <thead>
      <td>X</td>
      <td>Z</td>
      <td>Dimensions</td>
    </thead>
    {#each results as result}
      <tr>
        <td>{result.x}</td>
        <td>{result.z}</td>
        <td>{result.w}x{result.h}</td>
      </tr>
    {/each}
  </table>
</div>

<style>
  td {
    min-width: 50px;
    text-align: center;
  }
</style>
