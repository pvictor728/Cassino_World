// SPDX-License-Identifier: MIT
pragma solidity ^0.5.1;

import "./Cassino.sol";

contract  SlotMachine is Cassino {
    
    event Victory(address jogador, uint quantidade);
    event Lose(address jogador, uint quantidade);
    event Draw(address jogador, uint quantidade);
    event MaquinaGirada(string nome, address sender, uint slot1, uint slot2, uint slot3);
    
    
    //the user plays one roll of the machine putting in money for the win
    function jogarSlotMachine() public{
        require(msg.sender != owner, "Dono do cassino nao pode realizar essa operacao");
        require(casaAberta == true, "Operacao negada, cassino fechado");
        require(jogadores[msg.sender].amount >= precoRodada, "Saldo insuficiente do jogador para jogar");
        require(saldoCassino >= precoRodada * 50, "Maquina nao possui dinheiro suficiente para resgate");
        jogadores[msg.sender].amount -= precoRodada;
        saldoCassino += precoRodada;
        uint slot1 = uint(keccak256(abi.encodePacked(now, msg.sender))) % 7;
        uint slot2= uint(keccak256(abi.encodePacked(now+10, msg.sender))) % 7;
        uint slot3 = uint(keccak256(abi.encodePacked(now+20, msg.sender))) % 7;
        uint premio = calcularPremio(slot1, slot2, slot3);
        jogadores[msg.sender].amount += premio;
        saldoCassino -= premio;
        emit MaquinaGirada(jogadores[msg.sender].nome, jogadores[msg.sender].endereco, slot1, slot2, slot3);
        if (premio == 0){
            emit Lose(jogadores[msg.sender].endereco, precoRodada);
        }else if(premio == precoRodada){
            emit Draw(jogadores[msg.sender].endereco, precoRodada);
        }else{
            emit Victory(jogadores[msg.sender].endereco, premio); 
        }
    }
    
    function calcularPremio(uint slot1, uint slot2, uint slot3) internal view returns (uint) {
        if (slot1 == 0 && slot2 == 0 && slot3 == 0){
            return precoRodada * 50;
        } else if (slot1 == 6 && slot2 == 6 && slot3 == 6){
            return precoRodada * 30;
        } else if (slot1 == 5 && slot2 == 5 && slot3 == 5) {
            return precoRodada * 20;
        } else if (slot1 == 4 && slot2 == 4 && slot3 == 4) {
            return precoRodada * 15;
        } else if (slot1 == 3 && slot2 == 3 && slot3 == 3) {
            return precoRodada * 12;
        } else if (slot1 == 2 && slot2 == 2 && slot3 == 2) {
            return precoRodada * 10;
        } else if (slot1 == 1 && slot2 == 1 && slot3 == 1) {
            return precoRodada * 5;
        } else if ((slot1 == slot2) || (slot1 == slot3) || (slot2 == slot3)) {
            return precoRodada;
        } else {
            return 0;
        }
    }
}