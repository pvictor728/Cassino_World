// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Cassino {

    struct Jogador {
        address endereco;
        string nome;
        uint idade;
        mapping(string => uint) fichas;
    }

    address public owner;
    mapping(address => Jogador) public jogadores;
    uint controlejogadores = 0;
    uint public immutable fichade1 = 0.00016 ether;
    uint public immutable fichade5 = 0.00078 ether;
    uint public immutable fichade10 = 0.0016 ether;
    uint public immutable fichade20 = 0.0031 ether;
    uint public immutable fichade50 = 0.0078 ether;
    uint public immutable fichade100 = 0.016 ether;
    
    event CadastroRealizado(string nome, uint controlejogadores);
    event FichasCompradas(address pessoa, uint quntidade);
    event valorFichasResgatadas(Jogador pessoa, uint quantidade);
    event RodadaVencida(); //aqui é para os jogos,n irá ficar aqui

    constructor() public{
		owner = msg.sender;
    }
    
	modifier onlyOwner {
		require(msg.sender == owner.endereco, "Somento o dono do cassino pode executar essa funcao!");
		_;
	}

    function cadastrar(string nome, uint idade) public {
        require(idade >= 18, "Idade nao permitida para se cadastrar no cassino.");
        Jogador j = Jogador(msg.sender, nome, idade);
        j.fichas[fichade1] = 0;
        j.fichas[fichade5] = 0;
        j.fichas[fichade10] = 0;
        j.fichas[fichade20] = 0;
        j.fichas[fichade50] = 0;
        j.fichas[fichade100] = 0;
        jogadores[msg.sender] = j;
        controlejogadores += 1;
        emit CadastroRealizado(nome, controlejogadores);
    }

    function verFluxoJogadores() public view onlyOwner{
        return controlejogadores;
    }

    function mostrarValoresFichas() public view returns (string){
        return "Ficha de 1 = 0.00016 ether"
        "Ficha de 5 = 0.00078 ether"
        "Ficha de 10 = 0.0016 ether"
        "Ficha de 20 = 0.0031 ether"
        "Ficha de 50 = 0.0078 ether"
        "Ficha de 100 = 0.016 ether";
    }

    function ComprarFichas() public payable{
        require(msg.value >= fichade1, "Dinheiro insuficiente para comprar fichas!");
        uint8 fichas100 = msg.value / 0.016;
        jogadores[msg.sender].fichas[fichade100] += fichas100;
        //saldoemfichas += 0.016 * fichas100;
        uint8 fichas50 = (msg.value % 0.016) / 0.0078;
        jogadores[msg.sender].fichas[fichade50] += fichas50;
        //saldoemfichas += 0.0078 * fichas50;
        uint8 fichas20 = ((msg.value % 0.016) % 0.0078) / 0.0031;
        jogadores[msg.sender].fichas[fichade20] += fichas20;
        //saldoemfichas += 0.0031 * fichas20;
        uint8 fichas10 = (((msg.value % 0.016) % 0.0078) % 0.0031) / 0.0016;
        jogadores[msg.sender].fichas[fichade10] += fichas10;
        //saldoemfichas += 0.0016 * fichas10;
        uint8 fichas5 = ((((msg.value % 0.016) % 0.0078) % 0.0031) % 0.0016) / 0.00078;
        jogadores[msg.sender].fichas[fichade5] += fichas5;
        //saldoemfichas += 0.00078 * fichas5;
        uint8 fichas1 = (((((msg.value % 0.016) % 0.0078) % 0.0031) % 0.0016) % 0.00078) / 0.00016;
        jogadores[msg.sender].fichas[fichade1] += fichas1;
        //saldoemfichas += 0.00016 * fichas1;
        emit FichasCompradas(jogadores[msg.sender].nome, msg.value);
    }

    function MostrarBalanco() public view onlyOwner returns(uint){
        return address(this).balance;
    }

    function FecharCasa() public onlyOwner {  
        //vou adicionar essa funcao nos jogos
        require(msg.sender == owner, "Somente o dono do cassino pode fechar a casa");
        msg.sender.transfer(address(this).balance);
    }

    function resgatarValorFichas() public {
        uint saldo = jogadores[msg.sender].fichas[fichade100] * 0.016 ether;
        saldo += jogadores[msg.sender].fichas[fichade50] * 0.0078 ether;
        saldo += jogadores[msg.sender].fichas[fichade20] * 0.0031 ether;
        saldo += jogadores[msg.sender].fichas[fichade10] * 0.0016 ether;
        saldo += jogadores[msg.sender].fichas[fichade5] * 0.00078 ether;
        saldo += jogadores[msg.sender].fichas[fichade1] * 0.00016 ether;

        msg.sender.transfer(saldo);

        //Retirando as fichas do jogadr após a transacao
        jogadores[msg.sender].fichas[fichade100] = 0;
        saldo += jogadores[msg.sender].fichas[fichade50] = 0;
        saldo += jogadores[msg.sender].fichas[fichade20] = 0;
        saldo += jogadores[msg.sender].fichas[fichade10] = 0;
        saldo += jogadores[msg.sender].fichas[fichade5] = 0;
        saldo += jogadores[msg.sender].fichas[fichade1] = 0;
    }
}


contract  SlotMachine is Cassino {
    
    enum simbolos {Uva, Melancia, Morango, Chocolate, Cerveja, Sorvete, Pizza}

    simbolos Slot1;
    simbolos slot2;
    simbolos slot3;

    uint saldoMaquina;

    event Vitoria(address jogador, uint quantidade);
    event Derrota(address jogador, uint quantidade);

    constructor(address dono) public{
		owner = msg.sender;
    }
    
	modifier onlyOwner {
		require(msg.sender == owner, "Somento o dono pode executar essa funcao!");
		_;
	}

    function Play();

    //function MostrarFichas

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
        require(controle_quantidade_rifas >= 1, "Nao possui rifas suficientes para serem sorteadas");
        uint rifasorteada = uint(keccak256(abi.encodePacked(now, msg.sender))) % controle_quantidade_rifas;
        Vencedor = rifas[rifasorteada];
        emit Sorteio(Vencedor);
    }

    function sacarPremio() public {
        require(msg.sender == owner, "Somente o ganhador do sorteio pode sacar o premio");
        msg.sender.transfer(saldo/2);
        Vencedor = address(0);
        saldo = 0 ether; //Após sacar, o saldo do contrato é zerado
    }
}

contract Roulette {
    uint256 public immutable TIMEOUT_FOR_BANK_REVEAL = 1 days;
    uint256 public immutable ROULETTE_NUMBER_COUNT = 37;

    // prettier-ignore
    bool[37] isNumberRed = [false, true, false, true, false, true, false, true, false, true, false, false, true, false, true, false, true, false, true, true, false, true, false, true, false, true, false, true, false, false, true, false, true, false, true, false, true];

    struct GameRound {
        bytes32 bankHash;
        uint256 bankSecretValue;
        uint256 userValue;
        bool hasUserBetOnRed;
        uint256 timeWhenSecretUserValueSubmitted;
        uint256 lockedFunds;
    }

    mapping(address => bool) public hasRequestedGame;
    mapping(address => GameRound) public gameRounds;
    mapping(address => uint256) public registeredFunds;

    event NewGameRequest(address indexed user);

    function increaseFunds() external payable {
        require(msg.value > 0, "Must send ETH");
        registeredFunds[msg.sender] += msg.value;
    }

    function withdrawMoney() external {
        require(registeredFunds[msg.sender] > 0);

        uint256 funds = registeredFunds[msg.sender];
        registeredFunds[msg.sender] = 0;

        (bool wasSuccessful, ) = msg.sender.call{value: funds}("");
        require(wasSuccessful, "ETH transfer failed");
    }

    function initializeGame() external {
        require(!hasRequestedGame[msg.sender], "Already requested game");

        hasRequestedGame[msg.sender] = true;
        emit NewGameRequest(msg.sender);
    }

    function setInitialBankHash(bytes32 bankHash, address userAddress) external onlyOwner {
        require(gameRounds[userAddress].bankHash == 0x0, "Bank hash already set");
        gameRounds[userAddress].bankHash = bankHash;
    }

    function placeBet(
        bool hasUserBetOnRed,
        uint256 userValue,
        uint256 _betAmount
    ) external {
        require(gameRounds[msg.sender].bankHash != 0x0, "Bank hash not yet set");
        require(userValue == 0, "Already placed bet");
        require(registeredFunds[bankAddress] >= _betAmount, "Not enough bank funds");
        require(registeredFunds[msg.sender] >= _betAmount, "Not enough user funds");

        gameRounds[msg.sender].userValue = userValue;
        gameRounds[msg.sender].hasUserBetOnRed = hasUserBetOnRed;
        gameRounds[msg.sender].lockedFunds = _betAmount * 2;
        gameRounds[userAddress].timeWhenSecretUserValueSubmitted = block.timestamp;

        registeredFunds[msg.sender] -= _betAmount;
        registeredFunds[bankAddress] -= _betAmount;
    }

    function sendBankSecretValue(uint256 bankSecretValue, address userAddress) external {
        require(gameRounds[userAddress].userValue != 0, "User has no value set");
        require(gameRounds[userAddress].bankSecretValue == 0, "Already revealed");
        require(keccak256(abi.encodePacked(bankSecretValue)) == gameRounds[userAddress].bankHash, "Bank reveal not matching commitment");

        gameRounds[userAddress].bankSecretValue = bankSecretValue;

        _evaluateBet(userAddress);
        _resetContractFor(userAddress);

        gameRounds[userAddress].bankHash = bytes32(bankSecretValue);
    }

    function checkBankSecretValueTimeout() external {
        require(gameRounds[msg.sender].bankHash != 0, "Bank hash not set");
        require(gameRounds[msg.sender].bankSecretValue == 0, "Bank secret is set");
        require(gameRounds[msg.sender].userValue != 0, "User value not set");
        require(block.timestamp > (gameRounds[msg.sender].timeWhenSecretUserValueSubmitted + TIMEOUT_FOR_BANK_REVEAL), "Timeout not yet reached");

        registeredFunds[msg.sender] += gameRounds[msg.sender].lockedFunds;
        _resetContractFor(msg.sender);
    }

    function _resetContractFor(address userAddress) private {
        gameRounds[userAddress] = GameRound(0x0, 0, 0, false, 0, 0);
    }

    function _evaluateBet(address userAddress) private {
        uint256 random = gameRounds[userAddress].bankSecretValue ^ gameRounds[userAddress].userValue;
        uint256 number = random % ROULETTE_NUMBER_COUNT;
        uint256 winningAmount = gameRounds[userAddress].lockedFunds;

        bool isNeitherRedNorBlack = number == 0;
        bool isRed = isNumberRed[number];
        bool hasUserBetOnRed = gameRounds[userAddress].hasUserBetOnRed;

        address winner;

        if (isNeitherRedNorBlack) winner = bankAddress;
        else if (isRed == hasUserBetOnRed) winner = userAddress;
        else winner = bankAddress;

        registeredFunds[winner] += winningAmount;
    }
}


