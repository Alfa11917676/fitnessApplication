//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import '@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
contract fitnessContract is ERC1155Upgradeable, OwnableUpgradeable {


    mapping (bytes32 => uint) public tokenDetails;
    mapping (bytes32 => uint[]) public userLogDetails;
    uint public currentTokenId;
    uint public totalUser;

    ///@notice will be used once while deploying the contract
    function initialise (string memory uri) external initializer {
        __Ownable_init();
        __ERC1155_init(uri);
    }

    ///@notice trigger a new user wants to add with us
    ///@dev hash of user profile should be inserted here as userDetails
    function mintForUser (bytes32 userDetail) external onlyOwner {
        currentTokenId++;
        totalUser++;
        tokenDetails[userDetail] = currentTokenId;
        _mint(msg.sender,currentTokenId,1,'');
    }

    ///@notice trigger when a user leaves the platform
    ///@dev pass the tokenId assigned for the particular user
    function burnUserToken (bytes32 userDetail, uint tokenId) external onlyOwner {
        totalUser--;
        delete tokenDetails[userDetail];
        delete userLogDetails[userDetail];
        _burn(msg.sender,tokenId,1);
    }

    ///@notice trigger when a particular user logs the daily data
    function log(bytes32 userDetails, uint _calorieCount) external onlyOwner {
        require (tokenDetails[userDetails]>0,'Error:Adding User Who Is Not Added To The System');
        userLogDetails[userDetails].push(_calorieCount);
    }


    ///@notice view the total calorie input of the user till data
    ///@dev pass the userDetails hash in the argument
    function viewTotalLoggedDataPerUser (bytes32 userDetails) external view returns (uint) {
        uint totalCalorie;
        for (uint i =0; i< userLogDetails[userDetails].length; i++) {
            totalCalorie += userLogDetails[userDetails][i];
        }
        return totalCalorie;
    }

    ///@notice view the entire calorie chart of the user logged till date
    ///@dev pass the userDetails hash in the argument
    function viewLoggedDataPerUser (bytes32 userDetails) external view returns (uint[] memory) {
        return userLogDetails[userDetails];
    }

    //@notice changes the tokenUri in case it is changed
    //@dev pass the updated tokenUri
    function setUri (string memory _uri) external onlyOwner {
        _setURI(_uri);
    }



}
