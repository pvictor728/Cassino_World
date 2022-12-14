// SPDX-License-Identifier: MIT
pragma solidity ^0.5.1;

import "./SlotMachine.sol";

contract Roulette is SlotMachine {
  
  uint precoRodada = 0.01 ether;
  uint saldoNecessario = 0;
  uint momentoAposta = now;
  mapping (address => uint256) vencedores;
  uint8[] payouts = [2,3,3,2,2,36]; //os multiplicadores para cada tipo de aposta
  uint8[] numberRange = [1,2,2,1,1,36];
  
  /*
    BetTypes:
      0: color -> 0 para preto e 1 para vermelho
      1: column -> 0 para cair na esquerda, 1 para cair no meio, 2 para cair na direita
      2: dozen -> 0 para sair primeiro, 1 para sair na segunda, 2 para sair na terceira
      3: espaco -> 0 pra baixo, 1 para acima
      4: paridade -> par ou impar
      5: number -> 0 ate 36
  */
  
  struct Bet {
    address player;
    uint8 betType;
    uint8 number;
  }

  Bet[] public bets;
  
  event RandomNumber(uint256 number);
  
  function statusApostas() public view returns(uint, uint, uint, uint, uint) {
    require(msg.sender != owner,"Acao negada");
    return (
        bets.length,             // numero de apostas ativas
        bets.length * precoRodada, // valor de apostas ativas
        momentoAposta,      // quando podemos jogar novamente
        saldoCassino,   // saldo da casa
        vencedores[msg.sender]     // vencedores do jogo
    );}

  function criarAposta(uint8 number, uint8 betType) public {
    /* 
       Aposta válida quando:
       1 - o valor da aposta está correto (=precoRodada)
       2 - betType é conhecido (entre 0 e 5)
       3 - O numero apostado é valido
       4 - A casa tem fundos suficientes para pagar o debito
    */
    require(jogadores[msg.sender].amount >= precoRodada,"Saldo insuficiente");                               // 1
    require(betType >= 0 && betType <= 5);                         // 2
    require(number >= 0 && number <= 36);        // 3
    uint valorAposta = payouts[betType] * precoRodada;
    uint balancoProvisorio = saldoNecessario + valorAposta;
    require(balancoProvisorio < saldoCassino,"A casa nao possui saldo suficiente para suportar essa aposta");           // 4

    saldoNecessario += valorAposta;
    bets.push(Bet({
      betType: betType,
      player: msg.sender,
      number: number
    }));
  }

  function rodarRoleta() public {
    //Verificar se existe apostas feitas
    require(bets.length > 0,"Nenhuma aposta feita");
    //Verificar se epossivel rodar a roleta nesse momento
    require(now > momentoAposta,"nao e possivel girar a roleta nesse momento");
    momentoAposta = now;

    // Gerando numero aleatorio
    uint diff = block.difficulty;
    bytes32 hash = blockhash(block.number-1);
    Bet memory lb = bets[bets.length-1];
    uint number = uint(keccak256(abi.encodePacked(now, diff, hash, lb.betType, lb.player, lb.number))) % 37;
    
    //criando os casos de vitoria para o numero escolhido
    for (uint i = 0; i < bets.length; i++) {
      bool vitoria = false;
      Bet memory b = bets[i];
      if (number == 0) {
        vitoria = (b.betType == 5 && b.number == 0);                   /* apostou no 0 */
      } else {
        if (b.betType == 5) { 
          vitoria = (b.number == number);                              /* apostou no numero */
        } else if (b.betType == 4) {
          if (b.number == 0) vitoria = (number % 2 == 0);              /* apostou nos pares */
          if (b.number == 1) vitoria = (number % 2 == 1);              /* apostou nos ímpares */
        } else if (b.betType == 3) {            
          if (b.number == 0) vitoria = (number <= 18);                 /* apostou na primeira metade dos numeros */
          if (b.number == 1) vitoria = (number >= 19);                 /* apostou na segunda metade dos numeros */
        } else if (b.betType == 2) {                               
          if (b.number == 0) vitoria = (number <= 12);                 /* apostou na primeira duzia */
          if (b.number == 1) vitoria = (number > 12 && number <= 24);  /* apostou na segunda duzia */
          if (b.number == 2) vitoria = (number > 24);                  /* apostou na terceira duzia */
        } else if (b.betType == 1) {               
          if (b.number == 0) vitoria = (number % 3 == 1);              /* apostou nos numerais da coluna esquerda */
          if (b.number == 1) vitoria = (number % 3 == 2);              /* apostou nos numerais da coluna direita */
          if (b.number == 2) vitoria = (number % 3 == 0);              /* apostou nos numerais da coluna do meio */
        } else if (b.betType == 0) {
          if (b.number == 0) {                                     /* apostou no preto */
            if (number <= 10 || (number >= 20 && number <= 28)) {
              vitoria = (number % 2 == 0);
            } else {
              vitoria = (number % 2 == 1);
            }
          } else {                                                 /* bet on red */
            if (number <= 10 || (number >= 20 && number <= 28)) {
              vitoria = (number % 2 == 1);
            } else {
              vitoria = (number % 2 == 0);
            }
          }
        }
      }
      /* Se houver vitória, a aposta é retornada ao ganhador e estorquida da casa imediatamente */
      if (vitoria) {
        jogadores[b.player].amount += precoRodada * payouts[b.betType];
        saldoCassino -= precoRodada * payouts[b.betType];
      }
    }
    /* Apaga as apostas */
    bets.length = 0;
    /* Apaga o saldonecessario */
    saldoNecessario = 0;
    emit RandomNumber(number);
  }
}