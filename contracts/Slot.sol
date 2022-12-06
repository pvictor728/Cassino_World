pragma solidity ^0.5.1;

contract  Character {

    address owner;

    uint forca;
    uint destreza;
    uint inteligencia;
    uint constituicao;
    uint vida;
    uint mana;
    item itens[];
    
    //Na derrota, o jogador morre, perde todos os itens, e todos os itens são calculados e o valor vai ser dividido para o owner
    //e para o boss, podendo esse valor ser resgatado caso o boss venha a morrer
    event Morte(); 
    event Vitoria(address comprador, uint quant); //Na vitória, os monstros podem liberar itens valiosos
    event CompradeItem(); //Venda de itens que caem dos monstros e compra de equipamentos
    event restaurar(); //Através de porçoes ou ajuda médica(pago)


    constructor() public{
		forca = 1;
        destreza = 1;
        inteligencia = 1;
        constituicao = 1;
        vida = 100;
        mana - 100;
    }
    
	modifier onlyOwner {
		require(msg.sender == owner, "Somento o dono do personagem pode executar essa função!");
		_;
	}

    function ComprarRifa(uint quantrifas) public payable {
        require(msg.value >= preco_rifa * quantrifas, "Saldo insuficiente para comprar rifa(s)!");
        for (uint i=controle_quantidade_rifas; i< controle_quantidade_rifas + quantrifas; i++) {
            rifas[i] = msg.sender;
        }
        controle_quantidade_rifas += quantrifas;
        saldo += quantrifas * preco_rifa;
        emit RifaComprada(msg.sender, quantrifas);
    }

    function retornarPremio() public view returns (uint) {
        return saldo/2;
    }

    function totalRifasPessoal() public view returns (uint){
        uint numeroderifasdapessoa = 0;
        for (uint i=0;i<controle_quantidade_rifas;i++){
            if (rifas[i] == msg.sender){
                numeroderifasdapessoa++;
            }
        }
        return numeroderifasdapessoa;
    }

    function totalRifasGeral() public view returns (uint){
        return  controle_quantidade_rifas;
    }


    function sortearRifa() public onlyOwner{  
        require(controle_quantidade_rifas >= 1, "Não possui rifas suficientes para serem sorteadas");
        uint rifasorteada = uint(keccak256(abi.encodePacked(now, msg.sender))) % controle_quantidade_rifas;
        Vencedor = rifas[rifasorteada];
        emit Sorteio(Vencedor);
    }

    function sacarPremio() public {
        require(msg.sender == Vencedor, "Somente o ganhador do sorteio pode sacar o prêmio");
        msg.sender.transfer(saldo/2);
        Vencedor = address(0);
        saldo = 0 ether; //Após sacar, o saldo do contrato é zerado
    }
}