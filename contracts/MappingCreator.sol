pragma solidity 0.8.16;

contract MappingCreator {
    uint256 public lastEmptySlot = 3;
    mapping (uint256 => bytes2) public slotToType;
    enum MapType {
        STR,
        UINT,
        ADRESS,
        BYTES
    }

    function concateBytes(MapType _keyType, MapType _valType) internal view returns(bytes2 twoByte) {
        bytes2 twoByteKey = getLastOneByte(uint256(_keyType));
        bytes2 twoByteVal = getLastOneByte(uint256(_valType));
        twoByte = twoByteKey;
        twoByte = (twoByte  | (twoByteVal >> 8));
    }

    function getLastOneByte(uint256 _val) internal view returns(bytes1 lastOneByte) {
        bytes32 valToBytes = bytes32(_val);
        bytes1 lastOneByte = bytes1(valToBytes << 248);
        return lastOneByte;
    }

    function updateMapping(uint _slot, uint _mappingkey, uint256 _mappingValue) public {
        require(lastEmptySlot >= _slot, "This mapping not created yet.");
        // bytes32  hashed = keccak256(abi.encodePacked(_mappingValue));
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

    function createMapping(
        MapType _keyType, 
        MapType _valType,
        bytes32  _mappingKey, 
        bytes32  _mappingValue
        ) public {
        bytes2 concattedBytes = concateBytes(_keyType, _valType);
        slotToType[lastEmptySlot] = concattedBytes;
        
        assembly {
            mstore(0, _mappingKey)
            // Store slot number in scratch space after num
            mstore(32, sload(lastEmptySlot.slot))
            // Create hash from previously stored num and slot
            let hash := keccak256(0, 64)
            // Assign value of mapping created
            sstore(hash,_mappingValue)
            
            sstore(lastEmptySlot.slot, add(sload(lastEmptySlot.slot),1))
        }


    }


    function getMapping(bytes32 _mappingKey, uint256 _slot) public view returns (string memory strRes, uint256 uintRes, address adsRes, bytes memory bytRes) {
        bytes2 keyValTypes = slotToType[_slot];
        uint8 keyType = uint8(bytes1(keyValTypes));
        bytes2 reversedByte = (keyValTypes << 8 | (keyValTypes >> 8)); 
        uint8 valType = uint8(bytes1(reversedByte));
        bytes32 result;
        assembly {
            // Store num in memory scratch space (note: lookup "free memory pointer" if you need to allocate space)
            mstore(0, _mappingKey)
            // Store slot number in scratch space after num
            mstore(32, _slot)
            // Create hash from previously stored num and slot
            let hash := keccak256(0, 64)
            // Load mapping value using the just calculated hash
            result := sload(hash)
        //    switch valType
        //     case 0{
        //         strRes := result
        //     }
        //     case 1{
        //         uintRes := mload(add(result, add(0x20, 0)))
        //     }
        //     case 2{
        //         adsRes := result
        //     }
        //     case 3{
        //         bytRes := result
        //     }  
        }

        if(valType == 0){
            strRes = string(abi.encodePacked(result));
        }
        else if(valType == 1){
            uintRes = uint256(result);
        }
        else if(valType == 2){
            adsRes = address(uint160(uint256(result)));
        }
        else if(valType == 3){
            bytRes = abi.encodePacked(result);
        }
    }
}