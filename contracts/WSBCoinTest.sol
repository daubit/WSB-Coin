// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "./WSBCoin.sol";


contract WSBCoinTest is WSBCoin {

    function mint(address account, uint256 amount) public virtual {
        _mint(account,amount);
    }

    /*function burn(address account, uint256 amount) public virtual {
        _burn(account, amount);
    }*/
}