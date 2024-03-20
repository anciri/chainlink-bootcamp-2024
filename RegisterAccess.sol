// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
 
contract RegisterAccess {
	string[] private info; # la variable no es solamente una string sino que un array de string (los corchetes[]) #
	address public owner; # variable para almacenar direcciones de contratos o billetereas y es publica y la llamamos owner (En Solidity, cuando declaras una variable como pública, el compilador automáticamente genera funciones “getter” para esa variable de estado. Estas funciones permiten acceder al valor de la variable desde fuera del contrato.)#
	mapping (address => bool) public allowlist;  #variable de tipo mapa, que es una tabla en ese caso de direcciones con al lado un valor boolenano (si/no) que definirá si está o no autorizado a hacer algo #
 
	constructor() {
    	owner = msg.sender;
    	allowlist[msg.sender] = true;
	} 
# el Constructor es una funcion de solidity que viene llamada unicamente al despliegue del contrato#
 
	event InfoChange(string oldInfo, string newInfo); 
 
	modifier onlyOwner {
    	require(msg.sender == owner,"Only owner");
    	_;
	}
 
	modifier onlyAllowlist {
    	require(allowlist[msg.sender] == true, "Only allowlist");
    	_;
	} 
 
	function getInfo(uint index) public view returns (string memory) {
    	return info[index];
	}
 
	function setInfo(uint index, string memory _info) public onlyAllowlist {
    	emit InfoChange (info[index], _info);
    	info[index] = _info;
	}
 
	function addInfo(string memory _info) public onlyAllowlist returns (uint index) {
    	info.push (_info);
    	index = info.length -1;
	}
   
	function listInfo() public view returns (string[] memory) {
    	return info;
	}
 
	function addMember (address _member) public onlyOwner {        
    	allowlist[_member] = true;
	}
 
	function delMember (address _member) public onlyOwner {
    	allowlist[_member] = false;
	}    
}
