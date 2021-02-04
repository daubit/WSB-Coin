// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "./OpenZeppelin/IERC20.sol";
import "./math/SafeMath.sol";

/*contract Ownable {
    function owned() public {
        owner = msg.sender;
    }

    address owner;
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
}*/

contract WSBCoin is IERC20 {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    bool private initialized;

    /*constructor (uint256 initialSupply_, string memory name_, string memory symbol_) {
        _mint(msg.sender, initialSupply_);
        _name = name_;//for display only
        _symbol = symbol_;//for display only
        _decimals = 8;//for display only
    }*/

    //instead of constructor for upgradeability
    function initialize(
        uint256 initialSupply_,
        string memory name_,
        string memory symbol_
    ) public {
        require(!initialized, "Contract instance has already been initialized"); //allow initializing only once
        initialized = true;
        _name = name_; //for display only
        _symbol = symbol_; //for display only
        _decimals = 0; //for display only
        _mint(msg.sender, initialSupply_); //use mint method instead initializing the supply manually
    }

    function name() public virtual view returns (string memory) {
        return _name;
    }

    function symbol() public virtual view returns (string memory) {
        return _symbol;
    }

    function decimals() public virtual view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public virtual override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(
            msg.sender != address(0),
            "WSB: cant approve from the zero address"
        );
        require(spender != address(0), "WSB: cant approve to the zero address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        require(
            _allowances[sender][msg.sender] >= amount,
            "WSB: transfer amount exceeds allowance"
        );
        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(
            amount,
            "WSB: transfer amount exceeds allowance"
        );
        emit Approval(sender, msg.sender, amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(
            sender != address(0),
            "WSB: cant transfer from the zero address"
        );
        require(
            recipient != address(0),
            "WSB: cant transfer to the zero address"
        );
        require(
            recipient != address(this),
            "WSB: cant transfer to the contract address"
        );

        _balances[sender] = _balances[sender].sub(
            amount,
            "WSB: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _increaseAllowance(address spender, uint256 value)
        public
        returns (bool success)
    {
        return approve(spender, _allowances[spender][msg.sender].add(value));
    }

    function _decreaseAllowance(address spender, uint256 value)
        public
        returns (bool success)
    {
        require(
            _allowances[msg.sender][spender] >= value,
            "WSB: decreased allowance below zero"
        );
        return approve(spender, _allowances[spender][msg.sender].sub(value));
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "WSB: cant mint on zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "WSB: cant burn on zero adress");

        _balances[account] = _balances[account].sub(
            amount,
            "WSB: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
}
