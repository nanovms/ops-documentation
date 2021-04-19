Visual Studio Code Extension
====================

You can use Ops extension to manage your local unikernels in Visual Studio Code. Access the [marketplace](https://marketplace.visualstudio.com/items?itemName=nanovms.ops) to download or search for ops in Visual Studio Code extension explorer.

Use the shorcut `ctrl+shift+P` or `cmd+shift+P` to open the commands pallete and select one of the next commands.

<table>
  <thead>
    <tr>
      <th>Command</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Ops: Run</td>
      <td>Allows to select an elf or javascript file from the filesystem and launch the program on an unikernel.</td>
    </tr>
    <tr>
      <td>Ops: Stop</td>
      <td>Allows to select a running unikernel and stops the execution.</td>
    </tr>
    <tr>
      <td>Ops: Run open file</td>
      <td>Launches an unikernel with the file that is opened in the editor. Currently, this command only supports javascript files.</td>
    </tr>
    <tr>
      <td>Ops: Build</td>
      <td>Allows to select an elf file or javscript file and prepares a nanos image to run the program.</td>
    </tr>
  </tbody>
</table>
