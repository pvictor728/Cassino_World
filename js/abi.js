var abi = [
	{
		"constant": true,
		"inputs": [],
		"name": "mostrarBalancoCasa",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "statusApostas",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			},
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "jogarRoleta",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "depositar",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "verFluxoJogadores",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "fecharCasa",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_nome",
				"type": "string"
			},
			{
				"name": "idade",
				"type": "uint256"
			}
		],
		"name": "cadastrar",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "valorsaque",
				"type": "uint256"
			}
		],
		"name": "sacar",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "jogarSlotMachine",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "verPrecodeJogo",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "abrirCasa",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "bancajogador",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "adicionarDinheiroCassino",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_tourPrice",
				"type": "uint256"
			}
		],
		"name": "mudarPrecoRodada",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "number",
				"type": "uint8"
			},
			{
				"name": "betType",
				"type": "uint8"
			}
		],
		"name": "criarAposta",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "number",
				"type": "uint256"
			}
		],
		"name": "RandomNumber",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "jogador",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "quantidade",
				"type": "uint256"
			}
		],
		"name": "Victory",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "jogador",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "quantidade",
				"type": "uint256"
			}
		],
		"name": "Lose",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "jogador",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "quantidade",
				"type": "uint256"
			}
		],
		"name": "Draw",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "nome",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "sender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "slot1",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "slot2",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "slot3",
				"type": "uint256"
			}
		],
		"name": "MaquinaGirada",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "nome",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "endr",
				"type": "address"
			}
		],
		"name": "CadastroRealizado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "pessoa",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "quntidade",
				"type": "uint256"
			}
		],
		"name": "DepositoRealizado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "pessoa",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "quantidade",
				"type": "uint256"
			}
		],
		"name": "SaqueRealizado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [],
		"name": "CasaEncerrada",
		"type": "event"
	}
]