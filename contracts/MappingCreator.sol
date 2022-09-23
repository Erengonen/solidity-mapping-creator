pragma solidity 0.8.16;

contract MappingCreator {
    mapping (uint256 => address) public testMap;
    uint256[] public mappingSlots;


    function updateMapping(uint _slot, uint _mappingkey, address _mappingValue) public {
        require(mappingSlots[mappingSlots.length-1] >= _slot, "This mapping not created yet.");
        assembly {
            mstore(0, _mappingkey)
            // Store slot number in scratch space after num
            mstore(32, _slot)
            // Create hash from previously stored num and slot
            let hash := keccak256(0, 64)
            sstore(hash,_mappingValue)   
            // Load mapping value using the just calculated hash

        } 
    }

    function createMapping(uint _mappingKey, address _mappingValue) public returns(uint) {
        // let newHash := keccak256(add(_address, 0x20), mload(_address))
        uint256 lastEmptySlot;
        if(mappingSlots.length > 0) {
             lastEmptySlot = mappingSlots[mappingSlots.length-1] + 1;

        }else {
            // We have 2 storage variable inside the contract so slot 3 is empty.
            lastEmptySlot = 3;
        }
        
        assembly {
            mstore(0, _mappingKey)
            // Store slot number in scratch space after num
            mstore(32, lastEmptySlot)
            // Create hash from previously stored num and slot
            let hash := keccak256(0, 64)
            // Store the mapping value 
            sstore(hash,_mappingValue)
        } 
        mappingSlots.push(lastEmptySlot);

        return lastEmptySlot;
    }


    function getMapping(uint _mappingKey, uint _slot) public view returns (address result) {
        assembly {
            // Store num in memory scratch space (note: lookup "free memory pointer" if you need to allocate space)
            mstore(0, _mappingKey)
            // Store slot number in scratch space after num
            mstore(32, _slot)
            // Create hash from previously stored num and slot
            let hash := keccak256(0, 64)
            // Load mapping value using the just calculated hash
            result := sload(hash)
        } 
    }
}