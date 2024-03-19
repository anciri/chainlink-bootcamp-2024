// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Register { 
" en la primera linea se especifica que mi contrato se llama Regiter"
    string private info; 
" en la seguna linea se define una variable del tipo string (puede contener cualquier tipo de información ASHII) y de tipo privivado (en el sentido que puede ser evaluada unicamente dentro del smart ocntract por cuentas autorizadas y no por cualquiera, aunque es publico su valor) y el nombre de la variable es info"
    
    function getInfo() public view returns (string memory) {
        return info;
    }
" en la tercera linea se define una función que es publica (puede ser llamada dentro o fuera del contrato) y es del tipo view (no puede cambiar nada del contrato). Me tiene que devolver una lectura de tipo string alloncandola en memoria (no tiene que asignar ningun valor)."

    function setInfo(string memory _info) public {
        info = _info;
    }
" en la ulitma riga viene definida otra función que utiliza como entrada parametro tipo string almacenado en memoria asignado a la variable _info. La función es publica (puede ser llamada por otros contratos) y asigna el valor de la variable _info a info.
}
