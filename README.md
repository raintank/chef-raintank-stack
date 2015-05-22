# raintank-stack-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['raintank-stack']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### raintank-stack::default

Include `raintank-stack` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[raintank-stack::default]"
  ]
}
```

## License and Authors

Author:: Jeremy Bingham (<jeremy@raintank.io>)
