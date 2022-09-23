# Mapping Creator  [![Hardhat][hardhat-badge]][hardhat] [![License: MIT][license-badge]][license]

  
[gha-badge]: https://github.com/paulrberg/hardhat-template/actions/workflows/ci.yml/badge.svg

[hardhat]: https://hardhat.org/

[hardhat-badge]: https://img.shields.io/badge/Built%20with-Hardhat-FFDB1C.svg

[license]: https://opensource.org/licenses/MIT

[license-badge]: https://img.shields.io/badge/License-MIT-blue.svg

  

A Smart contract using assembly for creating, updating, read storage mapping from function. It's creates (uint256 => address) mapping. Contract stores the created mappings slots inside the mappingSlot list. Storing slot numbers inside the list is not efficient. It's doubles the gas cost. 

  

-  [Hardhat](https://github.com/nomiclabs/hardhat): compile, run and test smart contracts

-  [TypeChain](https://github.com/ethereum-ts/TypeChain): generate TypeScript bindings for smart contracts

  

## Getting Started


Create a new repository with this repo as the initial state.

  
  

## Usage

  

### Pre Requisites

  

Then, proceed with installing dependencies:

  

```sh

$ yarn install

```

  

### Compile

  

Compile the smart contracts with Hardhat:

  

```sh

$ yarn compile

```

  

## License

  

[MIT](./LICENSE.md) © Eren Gonen