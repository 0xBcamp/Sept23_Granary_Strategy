import { erc20ABI } from "wagmi";
export const vaultContract = {
  abi: [
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "address",
          name: "who",
          type: "address",
        },
        {
          indexed: false,
          internalType: "bytes4",
          name: "fsig",
          type: "bytes4",
        },
        {
          indexed: false,
          internalType: "bytes32",
          name: "keysHash",
          type: "bytes32",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "slot",
          type: "uint256",
        },
      ],
      name: "SlotFound",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "address",
          name: "who",
          type: "address",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "slot",
          type: "uint256",
        },
      ],
      name: "WARNING_UninitedSlot",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "",
          type: "string",
        },
      ],
      name: "log",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      name: "log_address",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "uint256[]",
          name: "val",
          type: "uint256[]",
        },
      ],
      name: "log_array",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "int256[]",
          name: "val",
          type: "int256[]",
        },
      ],
      name: "log_array",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "address[]",
          name: "val",
          type: "address[]",
        },
      ],
      name: "log_array",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "bytes",
          name: "",
          type: "bytes",
        },
      ],
      name: "log_bytes",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "bytes32",
          name: "",
          type: "bytes32",
        },
      ],
      name: "log_bytes32",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "int256",
          name: "",
          type: "int256",
        },
      ],
      name: "log_int",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "address",
          name: "val",
          type: "address",
        },
      ],
      name: "log_named_address",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "uint256[]",
          name: "val",
          type: "uint256[]",
        },
      ],
      name: "log_named_array",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "int256[]",
          name: "val",
          type: "int256[]",
        },
      ],
      name: "log_named_array",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "address[]",
          name: "val",
          type: "address[]",
        },
      ],
      name: "log_named_array",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "bytes",
          name: "val",
          type: "bytes",
        },
      ],
      name: "log_named_bytes",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "bytes32",
          name: "val",
          type: "bytes32",
        },
      ],
      name: "log_named_bytes32",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "int256",
          name: "val",
          type: "int256",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "decimals",
          type: "uint256",
        },
      ],
      name: "log_named_decimal_int",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "val",
          type: "uint256",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "decimals",
          type: "uint256",
        },
      ],
      name: "log_named_decimal_uint",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "int256",
          name: "val",
          type: "int256",
        },
      ],
      name: "log_named_int",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "string",
          name: "val",
          type: "string",
        },
      ],
      name: "log_named_string",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "key",
          type: "string",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "val",
          type: "uint256",
        },
      ],
      name: "log_named_uint",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "",
          type: "string",
        },
      ],
      name: "log_string",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "log_uint",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "bytes",
          name: "",
          type: "bytes",
        },
      ],
      name: "logs",
      type: "event",
    },
    {
      inputs: [],
      name: "DEPOSIT_AMT",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "IS_TEST",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "PRECISION_DECIMALS",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "WBTC_CAP",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "dataProvider",
      outputs: [
        {
          internalType: "contract IDataProvider",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "excludeArtifacts",
      outputs: [
        {
          internalType: "string[]",
          name: "excludedArtifacts_",
          type: "string[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "excludeContracts",
      outputs: [
        {
          internalType: "address[]",
          name: "excludedContracts_",
          type: "address[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "excludeSenders",
      outputs: [
        {
          internalType: "address[]",
          name: "excludedSenders_",
          type: "address[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "failed",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "incentiveController",
      outputs: [
        {
          internalType: "contract IAaveIncentives",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "lendingPool",
      outputs: [
        {
          internalType: "contract ILendingPool",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "loanToken",
      outputs: [
        {
          internalType: "contract IERC20Extented",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "maxiVault",
      outputs: [
        {
          internalType: "contract MaxiVault",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "priceOracle",
      outputs: [
        {
          internalType: "contract IPriceOracle",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "reaperVault",
      outputs: [
        {
          internalType: "contract IReaperVault",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "setUp",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "strategy",
      outputs: [
        {
          internalType: "contract Strategy",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "targetArtifactSelectors",
      outputs: [
        {
          components: [
            {
              internalType: "address",
              name: "addr",
              type: "address",
            },
            {
              internalType: "bytes4[]",
              name: "selectors",
              type: "bytes4[]",
            },
          ],
          internalType: "struct StdInvariant.FuzzSelector[]",
          name: "targetedArtifactSelectors_",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "targetArtifacts",
      outputs: [
        {
          internalType: "string[]",
          name: "targetedArtifacts_",
          type: "string[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "targetContracts",
      outputs: [
        {
          internalType: "address[]",
          name: "targetedContracts_",
          type: "address[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "targetInterfaces",
      outputs: [
        {
          components: [
            {
              internalType: "address",
              name: "addr",
              type: "address",
            },
            {
              internalType: "string[]",
              name: "artifacts",
              type: "string[]",
            },
          ],
          internalType: "struct StdInvariant.FuzzInterface[]",
          name: "targetedInterfaces_",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "targetSelectors",
      outputs: [
        {
          components: [
            {
              internalType: "address",
              name: "addr",
              type: "address",
            },
            {
              internalType: "bytes4[]",
              name: "selectors",
              type: "bytes4[]",
            },
          ],
          internalType: "struct StdInvariant.FuzzSelector[]",
          name: "targetedSelectors_",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "targetSenders",
      outputs: [
        {
          internalType: "address[]",
          name: "targetedSenders_",
          type: "address[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "test_constructor",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "test_depositShoulFailIfAmountIsZero",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "test_mintSharesOnDepositSuccess",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "test_shouldFailWhenDepositCapIsReached",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "test_shouldIncreaseCummulativeDeposit",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "test_shouldReceiveReaperVaultTokenOnDeposit",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "user1",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "user2",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "want",
      outputs: [
        {
          internalType: "contract IERC20Extented",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
  ],
};

export const wbtcContract = {
  abi: erc20ABI,
};
