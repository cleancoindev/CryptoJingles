pragma solidity ^0.4.18;

import './zeppelin/ownership/Ownable.sol';
import './ERC721.sol';
import './SampleStorage.sol';

contract Sample is Ownable {
    
    mapping (uint => address) internal tokensForOwner;
    mapping (address => uint[]) internal tokensOwned;
    mapping (uint => uint) internal tokenPosInArr;
    
    mapping (uint => uint) public tokenType;
    
    uint public numOfSamples;
    
    address public cryptoJingles;
    
    SampleStorage public sampleStorage;
    
    event Mint(address indexed _to, uint256 indexed _tokenId);
    
    modifier onlyCryptoJingles() {
        require(msg.sender == cryptoJingles);
        _;
    }
    
    function Sample(address _sampleStorage) public {
        sampleStorage = SampleStorage(_sampleStorage);
    }
    
    function mint(address _owner, uint _randomNum) public onlyCryptoJingles {
        
        uint sampleType = sampleStorage.getType(_randomNum);
        
        addSample(_owner, sampleType, numOfSamples);
        
        Mint(_owner, numOfSamples);
        
        numOfSamples++;
    }
    
    function setSampleType(uint _sampleId, uint _sampleType) public onlyCryptoJingles {
        tokenType[_sampleId] = _sampleType;
    }
    
    // Internal functions of the contract
    
    function addSample(address _owner, uint _sampleType, uint _sampleId) internal {
        tokensForOwner[_sampleId] = _owner;
        
        tokensOwned[_owner].push(_sampleId);
        
        tokenType[_sampleId] = _sampleType;
        
        tokenPosInArr[_sampleId] = tokensOwned[_owner].length - 1;
    }
    
    //TODO: check this again
    // find who owns that sample and at what position is it in the owners arr 
    // Swap that token with the last one in arr and delete the end of arr
    function removeSample(address _owner, uint _sampleId) public onlyCryptoJingles {
        uint length = tokensOwned[_owner].length;
        uint index = tokenPosInArr[_sampleId];
        uint swapToken = tokensOwned[_owner][length - 1];

        tokensOwned[_owner][index] = swapToken;
        tokenPosInArr[swapToken] = index;

        delete tokensOwned[_owner][length - 1];
        tokensOwned[_owner].length--;
        
        tokensForOwner[_sampleId] = 0x0;
        
    }
    
    function getSamplesForOwner(address _owner) public constant returns (uint[]) {
        return tokensOwned[_owner];
    }
    
    function getTokenType(uint _sampleId) public constant returns (uint) {
        return tokenType[_sampleId];
    }
    
    function isTokenOwner(uint _tokenId, address _user) public constant returns(bool) {
        return tokensForOwner[_tokenId] == _user;
    }
    
    function getAllSamplesForOwner(address _owner) public constant returns(uint[]) {
        uint[] memory samples = tokensOwned[_owner];
        
        uint[] memory usersSamples = new uint[](samples.length * 2);
        
        uint j = 0;
        
        for(uint i = 0; i < samples.length; ++i) {
            usersSamples[j] = samples[i];
            usersSamples[j + 1] = tokenType[samples[i]];
            j += 2;
        }
        
        return usersSamples;
    }
    
     // Owner functions 
    function setCryptoJinglesContract(address _cryptoJingles) public onlyOwner {
        cryptoJingles = _cryptoJingles;
    }
}