// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.0;

// has a map of addresses -> percentages
import "./Record.sol";

contract LabelContract {
    // owner of the label
    address public owner;
    
    // isrcs -> contract address
    mapping(string => address) public records;
    
    constructor() {
        owner = msg.sender;
    }
    
    /** 
     * @dev Create a new record contract.
     * @param _isrc isrc of record
     * @param _addresses addresses of rightsholders
     * @param _points percentages of rightsholders matched by index
     */
    function createRecord(string memory _isrc, uint8 _total_shareholders, address payable[] calldata _addresses, uint8[] calldata _points) external returns(address) {    
        Record record = new Record(_isrc, _total_shareholders, _addresses, _points);
        
        string memory isrc = _isrc;
        records[isrc] = address(record);
        return address(record);
    }
    
    
    /**
     * @dev Payout a record by isrc
     * @param _isrc isrc of record
     */
    function payout(string memory _isrc) external payable {
        address _address = records[_isrc];
        Record record = Record(_address);
        
        record.payout{value: msg.value}();
    }
}

