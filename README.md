## ERC-721 with IPFS Metadata (Sepolia) - Foundry + Cast

A compact demo that **deploys an ERC-721**, **stores tokenURI**, and **serves metadata & image from IPFS** (Pinata).  
We deploy to **Sepolia**, verify on **Etherscan**, mint **token #0** with an IPFS metadata CID, and read it back via `cast`.

## Key Takeaways
- Use **Foundry** (forge/cast) to build, test, deploy, and interact.
- Keep metadata **off-chain on IPFS**, reference it **on-chain via tokenURI**.
- Never commit secrets; use **.env** + **.gitignore**.

## Prerequisites

### Install Foundry:

```shell
curl -L https://foundry.paradigm.xyz | bash

foundryup
```

### Install OpenZeppelin:

### foundry.toml (example)
```shell
forge install OpenZeppelin/openzeppelin-contracts
```
```shell
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
optimizer = true
optimizer_runs = 200

[rpc_endpoints]
sepolia = "${RPC_URL}"

[etherscan]
sepolia = { key = "${ETHERSCAN_API_KEY}" }
```

### Contracts & Scripts

#### src/MyNFT.sol
- ERC-721 using ERC721URIStorage + Ownable.
- mintWithURI(address to, string memory uri) mints to to and saves tokenURI
- nextTokenId auto-increments

#### script/DeployMyNFT.s.sol
- Deploys MyNFT to Sepolia, logs the address, and supports --verify.

#### test/MyNFT.t.sol
- Minimal tests: name/symbol + mintWithURI flow.

### Environment Variables (.env)

```shell
# Sepolia RPC (e.g., Infura)
RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID

# Deployer (Metamask private key, 0x-prefixed)
PRIVATE_KEY=0xYOUR_PRIVATE_KEY

# For automatic verification
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY

# (optional) Pinata if you upload metadata via API
PINATA_API_KEY=YOUR_PINATA_KEY
PINATA_API_SECRET=YOUR_PINATA_SECRET
# or: PINATA_JWT=eyJhbGciOi...
```

#### Explanation:
- RPC_URL = where transactions are sent.
- PRIVATE_KEY = account used for deploy/mint (fund it with Sepolia ETH).
- ETHERSCAN_API_KEY = contract verification.

### .gitignore
```shell
.env
out/
cache/
.vscode/
.idea/
.DS_Store
```

### Commands to Run
#### 1) Build & Test

```shell
forge build
forge test -vv
```

#### 2) Deploy (Sepolia) & Verify

```shell
source .env
forge script script/DeployMyNFT.s.sol \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  -vvvv
```
- Output includes: Contract Address: 0x... (use this for minting).

#### 3) Mint token #0 with IPFS metadata

- Set your metadata CID (from Pinata/IPFS) and contract address:

```shell
# example CIDs used in this project:
META_CID=QmVsFnSKwD4qsGgemcEknBFMY4z264bvXRS21TTbdmHhJR
NEW_CONTRACT=0x4d4f1Ca14f07c0b6cf689bdAaafF307d24A2741B

OWNER=$(cast wallet address --private-key "$PRIVATE_KEY")

# mint with tokenURI = ipfs://<CID>
cast send "$NEW_CONTRACT" \
  "mintWithURI(address,string)" "$OWNER" "ipfs://$META_CID" \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"
```

#### 4) Read back (owner & tokenURI)

```shell
# ownerOf(0)
cast call "$NEW_CONTRACT" "ownerOf(uint256)" 0 --rpc-url "$RPC_URL"

# tokenURI(0) (decode to a string)
cast abi-decode "string" \
  $(cast call "$NEW_CONTRACT" "tokenURI(uint256)" 0 --rpc-url "$RPC_URL")
```

### Sample Outputs

```shell
Deploy

Contract Address: 0x4d4f1Ca14f07c0b6cf689bdAaafF307d24A2741B
Pass - Verified


Mint

status 1 (success)  transactionHash 0x...


Read

ownerOf(0) -> 0xF8A8F8BB42C680Fd5C1EEd2d1c5D638E2C4f4B78
tokenURI(0) -> ipfs://QmVsFnSKwD4qsGgemcEknBFMY4z264bvXRS21TTbdmHhJR
```

### Handy Links (public)

Etherscan (Sepolia) contract:
https://sepolia.etherscan.io/address/0x4d4f1ca14f07c0b6cf689bdaaaff307d24a2741b

Metadata JSON (IPFS):
https://ipfs.io/ipfs/QmVsFnSKwD4qsGgemcEknBFMY4z264bvXRS21TTbdmHhJR

Image (IPFS):
https://ipfs.io/ipfs/bafkreif6kchn5vrhalotfhh3mrv3s7ps3lozrblslhia2n4m2yk3usftwq

### Caution

- Never commit .env, private keys, or seed phrases.
- If a secret leaks, rotate it immediately (new key/API key, move funds).
- Testnets (Sepolia) are public; all addresses & CIDs are inherently visible.

### End of the project.
