// ENDEREÇO EHTEREUM DO CONTRATO
var contractAddress = "0xD7bE49ebda43B381dCa355fA02A59ff6E8bc166D";

// Inicializa o objeto DApp
document.addEventListener("DOMContentLoaded", onDocumentLoad);
function onDocumentLoad() {
  DApp.init();
}

// Nosso objeto DApp que irá armazenar a instância web3
const DApp = {
  web3: null,
  contracts: {},
  account: null,

  init: function () {
    return DApp.initWeb3();
  },

  // Inicializa o provedor web3
  initWeb3: async function () {
    if (typeof window.ethereum !== "undefined") {
      try {
        const accounts = await window.ethereum.request({ // Requisita primeiro acesso ao Metamask
          method: "eth_requestAccounts",
        });
        DApp.account = accounts[0];
        window.ethereum.on('accountsChanged', DApp.updateAccount); // Atualiza se o usuário trcar de conta no Metamaslk
      } catch (error) {
        console.error("Usuário negou acesso ao web3!");
        return;
      }
      DApp.web3 = new Web3(window.ethereum);
    } else {
      console.error("Instalar MetaMask!");
      return;
    }
    return DApp.initContract();
  },

  // Atualiza 'DApp.account' para a conta ativa no Metamask
  updateAccount: async function() {
    DApp.account = (await DApp.web3.eth.getAccounts())[0];
    atualizaInterface();
  },

  // Associa ao endereço do seu contrato
  initContract: async function () {
    DApp.contracts.Roulette = new DApp.web3.eth.Contract(abi, contractAddress);
    return DApp.render();
  },

  // Inicializa a interface HTML com os dados obtidos
  render: async function () {
    inicializaInterface();
  },
};

let arraySimboli = [
  '🍀',
  '💎',
  '🍺',
  '🍕',
  '🍒',
  '🍇',
  '🥦'
];

document.getElementById('slot1').innerHTML = arraySimboli[0];
document.getElementById('slot2').innerHTML = arraySimboli[1];
document.getElementById('slot3').innerHTML = arraySimboli[4];

// *** MÉTODOS (de consulta - view) DO CONTRATO ** //

function mostrarBalancoCasa() {
  return DApp.contracts.Roulette.methods.mostrarBalancoCasa().call({ from: DApp.account });
}

function bancajogador() {
  return DApp.contracts.Roulette.methods.bancajogador().call({ from: DApp.account });
}

function verFluxoJogadores() {
  return DApp.contracts.Roulette.methods.verFluxoJogadores().call({ from: DApp.account });
}

function statusApostas() {
  return DApp.contracts.Roulette.methods.statusApostas().call({ from: DApp.account });
}

function verPrecodeJogo() {
  return DApp.contracts.Roulette.methods.verPrecodeJogo().call();
}

// *** MÉTODOS (de escrita) DO CONTRATO ** //

function depositar() {
  let quant = document.getElementById("Valor").value;
  return DApp.contracts.Roulette.methods.depositar().send({ from: DApp.account, value: quant }).then(atualizaInterface);;
}

function adicionarDinheiroCassino(){
  let quant = document.getElementById("Valor").value;
  return DApp.contracts.Roulette.methods.adicionarDinheiroCassino().send({ from: DApp.account, value: quant }).then(atualizaInterface);;
}

// exemplo DApp.contracts.Roulette.methods.depositar(aqui bota os parametros da funcao do smart contrat).

function sacar() {
  let quant = document.getElementById("Valor").value;
  return DApp.contracts.Roulette.methods.sacar(quant).send({ from: DApp.account, value: quant }).then(atualizaInterface);;
}

function mudarPrecoRodada(){
  let quant = document.getElementById("Novo preço").value;
  return DApp.contracts.Roulette.methods.mudarPrecoRodada(quant).send({ from: DApp.account }).then(atualizaInterface);;
}

function jogarSlotMachine(){
  
  document.getElementById("button-slot").disabled = true;

  DApp.contracts.Roulette.methods.jogarSlotMachine()

  return DApp.contracts.Roulette.methods.jogarSlotMachine().send({ from: DApp.account }).then(atualizaInterface);;
}

function jogarRoleta(){

}

function abrirCasa(){

}

function fecharCasa(){

}

function criarAposta(){

}

function cadastrar(){
  let nome = document.getElementById("Nome").value;
  let idade = document.getElementById("Idade").value
  return DApp.contracts.Rifa.methods.cadastrar(nome,idade).send({ from: DApp.account }).then(atualizaInterface);;
}




//SlotMachine


function game(){
 
  document.getElementById("button-slot").disabled = true;

  const attempts = numberAttempts(3,12);

  let t1 = 0, t2 = 0, t3 = 0;

  let slot1 = setInterval(function(){
    numberRandom = generaRandom(arraySimbols.length);
    document.getElementById("slot1").innerHTML = arraySimbols[numberRandom ];
    console.log(arraySimbols[numberRandom ]);
    t1++;
    if (t1 == attempts) {
      clearInterval(slot1);
      return null;
    }
  }, 100);

  let slot2 = setInterval(function(){
    t2++;
    if (t2 == attempts) {
      clearInterval(slot2);
      return null;
    }
    numberRandom = generaRandom(arraySimbols.length);
    document.getElementById("slot2").innerHTML = arraySimbols[numberRandom ];
    console.log(arraySimbols[numberRandom ]);
  }, 100);

  let slot3 = setInterval(function(){
    t3++;
    if (t3 == attempts) {
      clearInterval(slot3);
      victory();
      document.getElementById("button-slot").disabled = false;
      return null;
    }
    numberRandom = generaRandom(arraySimbols.length);
    document.getElementById("slot3").innerHTML = arraySimbols[numberRandom ];
    console.log(arraySimbols[numberRandom ]);
  }, 100);

  function victory() {
    slot1 = document.getElementById("slot1").innerHTML;
    slot2 = document.getElementById("slot2").innerHTML;
    slot3 = document.getElementById("slot3").innerHTML;

    if (slot1 == slot2 && slot2 == slot3){
      document.getElementById("result").innerHTML = 'YOU WON';
    } else {
      document.getElementById("result").innerHTML = 'YOU LOST';
    }
  }
}


function generaRandom(max){
	return Math.floor((Math.random() *  max));
}

function numberAttempts(min, max){
	return Math.floor((Math.random() * (max-min + 1)) + min);
}


// *** ATUALIZAÇÃO DO HTML *** //

function inicializaInterface() {
    document.getElementById("btnDepositar").onclick = depositar;
    document.getElementById("btnSacar").onclick = sacar;
    
    //document.getElementById("button-slot").onclick = jogarSlotMachine;
    
    atualizaInterface();
    //DApp.contracts.Roulette.getPastEvents("RifaComprada", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventos(result));  
    //DApp.contracts.Roulette.events.RifaComprada((error, event) => registraEventos([event]));  
}

function atualizaInterface() {
  verRifas().then((result) => {
    document.getElementById("total-rifas").innerHTML = result;
  });

  verTotalDeRifas().then((result) => {
    document.getElementById("total-geral").innerHTML = result;
  });

  verPremio().then((result) => {
    document.getElementById("premio").innerHTML =
      result / 1000000000000000000 + " ETH";
  });

  verPrecodeJogo().then((result) => {
    document.getElementById("preco").innerHTML =
      "Preço do jogo: " + result + " ETH";
  });

  verGanhador().then((result) => {
    document.getElementById("ganhador").innerHTML = result;
  });

  document.getElementById("endereco").innerHTML = DApp.account;

  document.getElementById("btnSortear").style.display = "none";
  ehDono().then((result) => {
    if (result) {
      document.getElementById("btnSortear").style.display = "block";
    }
  });
}

const alertPlaceholder = document.getElementById('liveAlertPlaceholder')

const alert = (message, type) => {
  const wrapper = document.createElement('div')
  wrapper.innerHTML = [
    `<div class="alert alert-${type} alert-dismissible" role="alert">`,
    `   <div>${message}</div>`,
    '   <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>',
    '</div>'
  ].join('')

  alertPlaceholder.append(wrapper)
}

const alertTrigger = document.getElementById('liveAlertBtn')
if (alertTrigger) {
  alertTrigger.addEventListener('click', () => {
    alert('Nice, you triggered this alert message!', 'success')
  })
}

/*function registraEventos(eventos) {
  let table = document.getElementById("events");
  eventos.forEach(evento => {
    let tr = document.createElement("tr");
    let td1 = document.createElement("td");
    td1.innerHTML = "<a href='https://sepolia.etherscan.io/address/"+ evento["returnValues"]["comprador"] +"'>" + evento["returnValues"]["comprador"] + "</a>";
    let td2 = document.createElement("td");
    td2.innerHTML = evento["returnValues"]["quant"];
    let td3 = document.createElement("td");  
    td3.innerHTML = "<a href='https://sepolia.etherscan.io/tx/"+ evento["transactionHash"] +"'>" + evento["transactionHash"] + "</a>";
    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    table.appendChild(tr);
  });
}*/
