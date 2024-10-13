// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20Token is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Constructor untuk inisialisasi nama, simbol, dan total supply awal
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        owner = msg.sender; // Owner kontrak adalah pengirim transaksi
    }

    // Fungsi untuk mendapatkan nama token
    function name() public view override returns (string memory) {
        return _name;
    }

    // Fungsi untuk mendapatkan simbol token
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    // Fungsi untuk mendapatkan desimal token
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    // Fungsi untuk mendapatkan total supply token
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    // Fungsi untuk mendapatkan saldo dari suatu alamat
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    // Fungsi untuk transfer token ke alamat lain
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    // Fungsi untuk mendapatkan allowance (izin transfer dari owner ke spender)
    function allowance(address owner_, address spender) public view override returns (uint256) {
        return _allowances[owner_][spender];
    }

    // Fungsi untuk memberikan izin kepada spender untuk mentransfer token dari owner
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    // Fungsi untuk transfer token dari satu alamat ke alamat lain (dengan izin)
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    // Fungsi untuk mencetak token baru (hanya dapat dilakukan oleh pemilik kontrak)
    function mint(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");
        _totalSupply += amount;
        _balances[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    // Fungsi internal untuk mentransfer token
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from zero address");
        require(recipient != address(0), "Transfer to zero address");
        require(_balances[sender] >= amount, "Insufficient balance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    // Fungsi internal untuk mengatur izin transfer
    function _approve(address owner_, address spender, uint256 amount) internal {
        require(owner_ != address(0), "Approve from zero address");
        require(spender != address(0), "Approve to zero address");

        _allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }
}
