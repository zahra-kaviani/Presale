pragma solidity >= 0.4.21 < 0.9.0;

import "ERC20.sol";
import "console.sol";
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 * @notice https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
 */
library SafeMath {
  /**
   * SafeMath mul function
   * @dev function for safe multiply
   **/
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
  
  /**
   * SafeMath div funciotn
   * @dev function for safe devide
   **/
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
  
  /**
   * SafeMath sub function
   * @dev function for safe subtraction
   **/
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
  
  /**
   * SafeMath add fuction 
   * @dev function for safe addition
   **/
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


/**
 * @title ERC20Basic
 * @dev Simple version of ERC20 interface
 * @notice https://github.com/ethereum/EIPs/issues/179
 */
contract myERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public  returns (uint256);
  function transfer(address to, uint256 value) public  returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  function allowance(address owner, address spender) public  returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title BasicToken
 * @dev Basic version of Token, with no allowances.
 */
contract BasicToken is myERC20Basic {
  using SafeMath for uint256;
  mapping(address => uint256) balances;

  /**
   * BasicToken transfer function
   * @dev transfer token for a specified address
   * @param _to address to transfer to.
   * @param _value amount to be transferred.
   */
  function transfer(address to, uint256 value) public returns (bool) {
    //Safemath fnctions will throw if value is invalid
    balances[msg.sender] = balances[msg.sender].sub(value);
    balances[to] = balances[to].add(value);
    emit Transfer(msg.sender, to, value);
    return true;
  }

  /**
   * BasicToken balanceOf function 
   * @dev Gets the balance of the specified address.
   * @param _owner address to get balance of.
   * @return uint256 amount owned by the address.
   */
  function balanceOf(address owner) public  returns (uint256 bal) {
    return balances[owner];
  }
}


/**
 *  @title ERC20 interface
 *  @notice https://github.com/ethereum/EIPs/issues/20
 */

/**
 * @title Token
 * @dev Token to meet the ERC20 standard
 * @notice https://github.com/ethereum/EIPs/issues/20
 */
contract Token is  BasicToken {
  mapping (address => mapping (address => uint256)) allowed;
  
  /**
   * Token transferFrom function
   * @dev Transfer tokens from one address to another
   * @param _from address to send tokens from
   * @param _to address to transfer to
   * @param _value amout of tokens to be transfered
   */
  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    uint256 allowance = allowed[from][msg.sender];
    // Safe math functions will throw if value invalid
    balances[to] = balances[to].add(value);
    balances[from] = balances[from].sub(value);
    allowed[from][msg.sender] = allowance.sub(value);
    emit Transfer(from, to, value);
    return true;
  }

  /**
   * Token approve function
   * @dev Aprove address to spend amount of tokens
   * @param _spender address to spend the funds.
   * @param _value amount of tokens to be spent.
   */
  function approve(address spender, uint256 value) public returns (bool) {
    // To change the approve amount you first have to reduce the addresses`
    // allowance to zero by calling `approve(_spender, 0)` 
    assert((value == 0) || (allowed[msg.sender][spender] == 0));

    allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * Token allowance method
   * @dev Ckeck that owners tokens is allowed to send to spender
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifing the amount of tokens still available for the spender.
   */
  function allowance(address owner, address spender) public view returns (uint256 remaining) {
    return allowed[owner][spender];
  }
}

/**
 * @title music Token
 * @dev Simple ERC20 Token with standard token functions.
 */
 
contract musicToken is Token {
  string public constant NAME = "music Token";
  string public constant SYMBOL = "msc";
  uint256 public constant DECIMALS = 18;

  uint256 public constant INITIAL_SUPPLY = 500000000 * 10**18;

  /**
   * @dev Create and issue tokens to msg.sender.
   */
  function mscToken() public {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}

contract SuperToken is ERC20 {
   
    struct stakeHolder {
       address adr;
        uint256 amountStaked;
        uint256 timeOfStaking;
    } 
    stakeHolder[] stakeholders;

    // mapping to track users who have staked
    mapping(address => stakeHolder ) public stakes;
    
   
    // struct to store details of token seller
    struct listing {
        uint256 id;
        address adr;
        uint256 tokens4Sale;
        uint256 tokenPrice;
    }
    listing[] Listing;

    //mapping to store ID against listings
    mapping (uint256 => listing) public allListings;
    uint256 public id;

    constructor() ERC20("musicToken","mT") {
        mint(msg.sender,10000000 * 10**18); //minting into owner wallet
    }

    // custom transfer function burning 2% of the transaction cost
     function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = msg.sender;
       uint256 burnAmount = amount * 2 / 100;
        burn(owner, burnAmount );
        amount = amount - burnAmount;
        transfer(owner, to, amount);
        return true;
    }
  
    // function to stake tokens
    function staking(uint256 amount) public {
         uint256 timestamp = block.timestamp;
         transfer(address(this), amount);
         stakes[msg.sender] = stakeHolder(msg.sender,amount,timestamp);
         stakeholders.push(stakeHolder(msg.sender,amount,timestamp));
    }

    // for getting reward per amount and time staked
    function getReward() public{
        uint256 currentTimestamp = block.timestamp;
        uint256 stakingTime  = (currentTimestamp - stakes[msg.sender].timeOfStaking);
        stakingTime = stakingTime ;  
        // require( stakingTime >= 1);
        uint256 rewardAmount = (stakes[msg.sender].amountStaked) * 2/100000 *stakingTime ; 
   
        transfer(address(this),msg.sender, rewardAmount);
     
    }

    // for unstaking tokens
    function unstake() public {
         transfer(address(this),msg.sender, stakes[msg.sender].amountStaked);
        
    }

    // to get all the addresses that have staked
    function getStakeHolders() public view returns  (stakeHolder [] memory){
        return stakeholders;
    }

    // for users to create listing
    function sellTokens(uint256 noOfTokens, uint256 tokenPrice) public {
     require( msg.sender != address(0));
     require( noOfTokens < balanceOf(msg.sender), "You donot have enough tokens to sell");
     id++;
     allListings[id] = listing(id,msg.sender,noOfTokens,tokenPrice);
     Listing.push(listing(id,msg.sender,noOfTokens,tokenPrice));
       
    }

    // get the list of tokens for sale
    function getListings() public view returns (listing [] memory) {
        return Listing;
    }
    
    // for buying tokens through listing
    function buyToken(uint256 id, uint256 amount) public {
        
        if (amount < allListings[id].tokenPrice) revert();
        transfer(allListings[id].adr,msg.sender, allListings[id].tokens4Sale);
        transfer(allListings[id]._adr, amount);
        allListings[id] = listing(0,address(0),0,0);
        uint256 index = 0;
        uint256 listLength = Listing.length;
        for ( uint256 i = 0; i < listLength; i++){
            if ( id == Listing[i].id){
                index = i;
            }
        }
        Listing[index] = Listing[listLength - 1];
        Listing.pop();

      

    }

    
}

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract Ballot {
   
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    struct Proposal {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    /** 
     * @dev Create a new ballot to choose one of 'proposalNames'.
     * @param proposalNames names of proposals
     */
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            // 'Proposal({...})' creates a temporary
            // Proposal object and 'proposals.push(...)'
            // appends it to the end of 'proposals'.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    /** 
     * @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
     * @param voter address of voter
     */
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /**
     * @dev Delegate your vote to the voter 'to'.
     * @param to address to which vote is delegated
     */
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate= voters[to];
        if (delegate.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate.weight += sender.weight;
        }
    }

    /**
     * @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.
     * @param proposal index of proposal in the proposals array
     */
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /** 
     * @dev Computes the winning proposal taking all previous votes into account.
     * @return winningProposal_ index of winning proposal in the proposals array
     */
    function winningProposal() public view
            returns (uint winningProposal)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }

    /** 
     * @dev Calls winningProposal() function to get the index of the winner contained in the proposals array and then
     * @return winnerName_ the name of the winner
     */
    function winnerName() public view
            returns (bytes32 winnerName)
    {
        winnerName = proposals[winningProposal()].name;
    }
}