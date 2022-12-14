// SPDX-License-Identifier: MIT
pragma solidity ^0.5.1;

contract Cassino {

    struct Jogador {
        address endereco;
        string nome;
        uint idade;
        uint amount;
    }


    address  owner;
    mapping(address => Jogador) jogadores;
    uint controlejogadores = 0;
    uint saldoCassino;
    bool cadastroFeito = false;
    bool casaAberta = true;

    
    event CadastroRealizado(string nome, address endr);
    event DepositoRealizado(address pessoa, uint quntidade);
    event SaqueRealizado(address pessoa, uint quantidade);
    event CasaEncerrada();
    

    constructor() public {
		owner = msg.sender;
    }
    
	modifier onlyOwner {
		require(msg.sender == owner, "Somento o dono do cassino pode executar essa funcao!");
		_;
	}

    function cadastrar(string memory _nome, uint idade) public {
        require(casaAberta == true, "Cassino fechado e cadastro indisponivel");
        require(msg.sender != owner, "Dono do cassino nao pode se cadastrar");
        require(cadastroFeito == false, "Usuario ja esta acadastrado");
        require(idade >= 18, "Idade nao permitida para se cadastrar no cassino.");
        jogadores[msg.sender] = Jogador(msg.sender, _nome, idade, 0);
        controlejogadores += 1;
        cadastroFeito = true;
        emit CadastroRealizado(_nome, msg.sender);
    }

    function verFluxoJogadores() public view onlyOwner returns(uint){
        return controlejogadores;
    }

    function adicionarDinheiroCassino() public payable onlyOwner{
        require(msg.value > 0, "Transacao negada");
        saldoCassino += msg.value;
    }

    function depositar() public payable{
        require(casaAberta == true, "Operacao indisponivel, cassino esta fechado");
        require(cadastroFeito == true, "Voce ainda nao possui uma conta, cadastre-se");
        jogadores[msg.sender].amount += msg.value;
        emit DepositoRealizado(msg.sender, msg.value);
    }

    function sacar(uint valorsaque) public{
        require(casaAberta == true, "Operacao indisponivel, cassino esta fechado");
        require(cadastroFeito == true, "Voce ainda nao possui uma conta, cadastre-se");
        require(jogadores[msg.sender].amount >= valorsaque, "Saldo insuficiente");
        msg.sender.transfer(valorsaque);
        emit SaqueRealizado(msg.sender, valorsaque);
    }

    function mostrarBalancoCasa() public view onlyOwner returns(uint){
        return saldoCassino;
    }

    function bancajogador() public view returns(uint){
        require(msg.sender != owner, "Operacao negada");
        require(casaAberta == true, "Operacao indisponivel, cassino esta fechado");
        require(cadastroFeito == true, "Sua banca ainda nao foi criada, cadastre-se");
        return jogadores[msg.sender].amount;
    }

    function fecharCasa() public onlyOwner {  
        require(msg.sender == owner, "Somente o dono do cassino pode fechar a casa");
        msg.sender.transfer(saldoCassino);
        casaAberta = false;
        saldoCassino = 0;
        //selfdestruct(owner);
        emit CasaEncerrada();
    }

    function abrirCasa() public onlyOwner {
        require(casaAberta == false, "O cassino ja esta aberto e operando");
        casaAberta = true;
    }
}