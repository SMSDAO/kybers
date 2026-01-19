# Foundry Dependencies

This project uses Foundry for smart contract development. Dependencies are managed via git submodules.

## Installation

To install all dependencies, run:

```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install foundry-rs/forge-std --no-commit
```

## Dependencies

- **OpenZeppelin Contracts**: v5.0.0+
  - Location: `lib/openzeppelin-contracts/`
  - Used for: Access control, token standards, security utilities

- **Forge Standard Library**: Latest
  - Location: `lib/forge-std/`
  - Used for: Testing utilities, console logging

## Building

After installing dependencies:

```bash
forge build
```

## Testing

```bash
forge test -vvv
```

## Note

Dependencies are not committed to the repository. You must install them locally after cloning.
