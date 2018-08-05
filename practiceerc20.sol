pragma solidity ^0.4.20;

contract Token {
    
    function totalSupply() constant returns (uint256 supply) {}
    
    function balanceOf(address _owner) returns (uint256 balance) {}
    
    function transfer(address _to, uint256 amount) returns (bool success) {}
    
    function transferfrom(address _from, address _to, uint256 amount) returns (bool success) {}
    
    function approve(address _spender, uint256 amount) returns (bool success) {}
    
    function allowance(address _owner, address _spender) returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract SandardToken is Token {
    uint256 public totalSupply;
    mapping (address => uint256) balances; 
    mapping (address => mapping(address => uint256)) allowed;
    
    function balanceOf(address _account) returns (uint256 balance) {
        return balances[_account];
    }
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        if(balances[msg.sender] > _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }
    
    function transferfrom(address _from, address _to, uint256 _value) returns (bool success) {
        if(allowed[_from][msg.sender] > _value 
            && balances[_from] > _value
            && _value > 0) 
        {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }
    
    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) returns (uint256 remaining) {
        allowed[_owner][_spender];
    }
}  

contract PracticeERC20 is SandardToken {
    
    string public name;
    uint8 public decimals;  
    string public symbol;
    string public version = 'H1.0'; 
    uint256 public unitsOneEthCanBuy;
    uint256 public totalEthInWei;
    address public fundsWallet;
    
    constructor() {
        balances[msg.sender] = 1000000000000000000000;
        totalSupply = 1000000000000000000000;
        name = "PracticeERC20";
        decimals = 18;
        symbol = "PERC20";
        unitsOneEthCanBuy = 10;  
        fundsWallet = msg.sender;
    }
    
    // tra
    function() payable{
        totalEthInWei = totalEthInWei + msg.value;
        uint256 amount = msg.value * unitsOneEthCanBuy;
        require(balances[fundsWallet] >= amount);
        
        balances[fundsWallet] = balances[fundsWallet] - msg.value;
        balances[msg.sender] = balances[msg.sender] + msg.value;
        Transfer(fundsWallet, msg.sender, msg.value);
        
        fundsWallet.transfer(msg.value);
    }
}

