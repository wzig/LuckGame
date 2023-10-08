// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Iterable2UintMapping {
    // Iterable mapping from address to uint;
    struct Map {
        mapping(uint => uint[]) keys;
        mapping(uint => mapping(uint => mapping(address => mapping(address => uint)))) values;
        mapping(uint => mapping(uint => mapping(address => address[]))) keys2;
        mapping(uint => mapping(uint => mapping(address => uint256))) poolTotal; // block/100 => 1/10/100/1000 => total
        mapping(uint => mapping(uint => mapping(address => address))) luckUser; //
        mapping(uint => mapping(uint => mapping(address => address))) drawler; //
        mapping(uint => address) allowMap;
        mapping(address => uint) allowMapRev;
    }

    function get(
        Map storage map,
        uint key,
        uint cap,
        address coin,
        address key2
    ) public view returns (uint) {
        return map.values[key][cap][coin][key2];
    }

    // function getKeyAtIndex(
    //     Map storage map,
    //     uint index
    // ) public view returns (uint) {
    //     return map.keys[index];
    // }

    // function getKeyAtIndex2(
    //     Map storage map,
    //     uint key,
    //     uint cap,
    //     uint index2
    // ) public view returns (address) {
    //     return map.keys2[key][cap][index2];
    // }

    // function size(Map storage map) public view returns (uint) {
    //     return map.keys.length;
    // }

    // function size2(
    //     Map storage map,
    //     uint key,
    //     uint cap
    // ) public view returns (uint) {
    //     return map.keys2[key][cap].length;
    // }

    function _add(
        Map storage map,
        uint key,
        uint cap,
        address coin,
        address key2,
        uint val,
        bool isAdd
    ) private {
        if (map.keys2[key][cap][coin].length == 0) {
            map.keys[cap].push(key);
        }
        if (map.values[key][cap][coin][key2] == 0) {
            map.keys2[key][cap][coin].push(key2);
        }
        if (isAdd) {
            map.values[key][cap][coin][key2] += val;
            map.poolTotal[key][cap][coin] += val;
        } else {
            map.values[key][cap][coin][key2] -= val;
            map.poolTotal[key][cap][coin] -= val;
        }
    }

    function add(
        Map storage map,
        uint key,
        uint cap,
        address coin,
        address key2,
        uint val
    ) public {
        _add(map, key, cap, coin, key2, val, true);
    }

    // function sub(
    //     Map storage map,
    //     uint key,
    //     uint cap,
    //     address key2,
    //     uint val
    // ) public {
    //     _add(map, key, cap, key2, val, false);
    // }
}
