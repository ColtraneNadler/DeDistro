// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.0;

/**
 * @dev struct for shareholder
 */
struct Share {
    // // address of shareholder
    address payable addr;
    
    // // percentage
    uint8 points;
}

/**
* @dev record contract
*/
contract Record {
    string public isrc;
    mapping(uint8 => Share) public shareholders;
    
    // mapping(address => uint8) public points;
    // mapping(uint8 => address) public addresses;
    uint8 public total_shareholders;
    
    /**
     * @dev for debugging purposes 
     */
    event test_value(uint256 indexed value1);
    
    constructor(string memory _isrc, uint8 _total_shareholders, address payable[] memory _addresses, uint8[] memory _points) {
        isrc = _isrc;
        total_shareholders = _total_shareholders;
        
        for(uint8 j = 0; j < total_shareholders; j++) {
            // addresses[j] = _addresses[j];
            // points[_addresses[j]] = _points[j]
            
            shareholders[j].addr = _addresses[j];
            shareholders[j].points = _points[j];
        }
    }
    
    /**
     * @dev checks to see if address is a shareholder
     */
    modifier isShareholder() {
        bool shareholder = false;
        
        for(uint8 j = 0; j < total_shareholders; j++) {
            if(shareholders[j].addr != msg.sender) continue;
            
            shareholder = true;
            break;
        }
        
        require(shareholder);
        _;
    }
    
    /**
     * @dev payout percentages
     * fallback to receive monies
     */
    function payout() public payable {
        for(uint8 j = 0; j < total_shareholders; j++) {
            Share memory _share = shareholders[j];
            
            // the amount of ether this shareholder will receive
            uint256 amount = msg.value * _share.points / 100;
            
            // send the ether to this shareholder's address
            _share.addr.transfer(amount);
        }
    }
    
    /**
     * @dev request purchase of points from a specific shareholder
     */
    function buyShare(address payable _addr, uint8 _points) public payable {
        // request to buy points from a shareholder
    }
    
    function approve() public {
        // approve request to purchase points
    }
    
    function deny() public {
        // deny request to purchase points
    }
    
    
    /**
     *  @dev give some points to new address / shareholder
     */
    function giveShare(address payable _addr, uint8 _points) public isShareholder {
        // shouldn't ever need to have more than 100 shareholders
        // hard coding at uint8 max ~ 255 for purpose of conditional
        uint8 sender_share_index = 255;
        
        // default to a new shareholder
        uint8 receiver_share_index = total_shareholders + 1;
        
        for(uint8 j = 0; j < total_shareholders; j++) {
            // find existing share struct
            if(shareholders[j].addr == msg.sender) {
                sender_share_index = j;
                
                if(receiver_share_index != total_shareholders + 1)
                    break;
            }
            
            // is receiving address already a shareholder
            else if(shareholders[j].addr == _addr) {
                receiver_share_index = j;
                
                // checking if sender_share_index has been found
                if(sender_share_index != 255)
                    break;
            }
        }
        
        /**
         * does the shareholder have enough points to give?
         */
        if(_points > shareholders[sender_share_index].points)
            revert("Not enough points to give.");
        
        /**
         * deduct points from sending shareholder
         */
        shareholders[sender_share_index].points -= _points;
        total_shareholders++;
        
        /**
         * give shares to existing or new shareholder
         */
        shareholders[receiver_share_index].addr = _addr;
        shareholders[receiver_share_index].points = _points;
    }
}
