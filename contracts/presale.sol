// SPDX-License-Identifier: MITtr

//we supposed that the clint thAT ASKED US TO Design token for, needed sone presale contract to raise some funds for his platform. so we designed this c
//contract
pragma solidity >=0.4.0 <=0.9.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
//SWC-107
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
//SWC-103
contract PragmaFixed {
    uint public x = 1;
}
contract Presale is OwnableUpgradeable {
    //total token sold
    uint256 public totalSold;
    //when presale start
    uint256 public startTime;
    //when presale end
    uint256 public endTime;
    //To change the claim start time by the owner new claim start time
    uint256 public claimStart;
    //sale toke address
    address public sale_add;
    uint256 public baseDecimals;
    //max token every one could have
    uint256 public maxtoken_each_prs;
    //for buy with usdt(tether=1 dollar)
    IERC20Upgradeable public USDT;
    //number of tokens
    uint256[9] public token_number;
    //value of token
    uint256[9] public token_price;
    mapping(address => uint256) public users_address;
    //these are events that in down rows we want to use them, to sure about process
    event SaleTimeSet(uint256 _start, uint256 _end, uint256 timestamp);
    event TokensClaimed(address indexed user,uint256 number,uint256 timestamp);
    event TokensAdded(address indexed token,uint256 Tokens_number,uint256 timestamp);
    event TokensBought(address indexed user,uint256 indexed tokensBought,address indexed purchaseToken,uint256 numberPaid,uint256 timestamp);

    constructor() initializer {}
    //Initializes the contract and sets parameters
    // like  Oracle contract to fetch USDT price, USDT token contract address, start and end time of the presale
    function initialize(address _oracle,address _usdt,uint256 _startTime,uint256 _endTime) external initializer {
        require(_oracle != address(0), "Zero address");
        require(_usdt != address(0), "Zero address");
        require(_startTime > block.timestamp && _endTime > _startTime,"time error");

        __Ownable_init_unchained();
        maxtoken_each_prs = 1000;
        baseDecimals = (10**18);
        token_number = [100000];
        token_price = [10000000000000000];
        USDT = IERC20Upgradeable(_usdt);
        startTime = _startTime;
        endTime = _endTime;
        emit SaleTimeSet(startTime, endTime, block.timestamp);
    }
    //calculate price of token
    function calculatePrice(uint256 _number)public view returns (uint256 Value) {
        uint256 value;
        require(_number <= maxtoken_each_prs, "max is 100");
        value = _number * token_price[1];
        return value;
    }
    //check the presale time that should be ok
    modifier sale_timecheck(uint256 number) {
        require(block.timestamp > startTime && block.timestamp < endTime,"time error");
        require(number > 0, "Invalid sale number");
        _;
    }
    //this function buy the token for user in presale time
    function buy(uint256 number) external sale_timecheck(number) returns (bool) {
        uint256 price = calculatePrice(number);
        price = price / (10**12);
        totalSold += number;
        users_address[_msgSender()] += (number * baseDecimals);
        //we can add here a requirment to sure that the address is true

        //emit the event tokensbought
        emit TokensBought(_msgSender(),number,address(USDT),price,block.timestamp);
        return true;
    }
    //When tokens become available, you can claim your tokens from Presale Smart Contract 
    //To claim tokens, send another transaction with the 0 value.
    function startClaim(uint256 _claimStart,uint256 Tokens_number,address _sale_add) external onlyOwner returns (bool) {
        require(_claimStart > endTime && _claimStart > block.timestamp,"claiming not started");
        //we can add here a requirment to sure that total tokens number is equal or less than sale token
        //check that the address isnt zero
        require(_sale_add != address(0));
        //chenck that the value of transaction is zero
        require(_claimStart == 0, "Claim ");
         claimStart = _claimStart;
         sale_add=_sale_add;
        IERC20Upgradeable(_sale_add).transferFrom(
            _msgSender(),
            address(this),
            Tokens_number
        );
        emit TokensAdded(sale_add, Tokens_number, block.timestamp);
        return true;
    }

    //we can add here a function that if in the climing time have a problem, can
    //change a climing time.

/*      function changeClaimStart(uint256 _claimStart)external onlyOwner returns (bool)
    {
        require(claimStart > 0, "claim start is wrong");
        require(_claimStart > endTime, "Sale is in progress");
        require(_claimStart > block.timestamp, "Claim time error");
        uint256 prevValue = claimStart;
        claimStart = _claimStart;
        emit ClaimStartUpdated(prevValue, _claimStart, block.timestamp);
        return true;
    }

*/
    //claim tokens after claiming starts
    function claim() external returns (bool) {
        require(sale_add != address(0));
        require(block.timestamp >= claimStart, "Claiming not started");
        uint256 number = users_address[_msgSender()];
        require(number > 0, "Nothing to claim");
        delete users_address[_msgSender()];
        IERC20Upgradeable(sale_add).transfer(_msgSender(), number);
        emit TokensClaimed(_msgSender(), number, block.timestamp);
        return true;
    }}
