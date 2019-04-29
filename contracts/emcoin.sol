pragma solidity ^0.4.24;

import "https://github.com/SMohata/EmissionCoin/node_modules/zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "https://github.com/SMohata/EmissionCoin/node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract emcoin is ERC721Token, Ownable {
  using SafeMath for uint256;
  address _owner;
  string public constant name = "EmissionCoin";
  string public constant symbol = "EMC";

  constructor() ERC721Token(name,symbol) public payable{

    _owner = msg.sender;

  }

  struct employee {
      uint e_id;
      string name;
      string dept;
      address e_add;
      uint ob_id;
      bool completed;
      uint objectives_completed;
  }

  struct objective {
      uint o_id;
      string description;
  }

  uint public oid=0;
  uint[] obj_arr;
  uint[] employee_arr;

  mapping (address => uint) public tokenbalance;
  mapping (uint => employee) public employeemapping;
  mapping (address => employee) public employeeaddmapping;
  mapping (uint => objective) public objectivemapping;

  function register_employee(uint eid,string memory _name,string memory _dept) public {
    employeemapping[eid]=employee(eid,_name,_dept,msg.sender,0,false,0);
    employeeaddmapping[msg.sender]=employee(eid,_name,_dept,msg.sender,0,false,0);
    employee_arr.push(eid);
  }

  function get_next_id() public {
    oid+=1;
  }

  function add_objective(string memory _des) public {
    get_next_id();
    objectivemapping[oid]=objective(oid,_des);
    obj_arr.push(oid);
  }

  function display_no_of_obj() public view returns(uint) {
    return obj_arr.length;
  }

  function display_obj_info(uint obid) public view returns(string memory) {
      return objectivemapping[obid].description;
  }

  function display_point_balance(uint id) public view returns(uint) {
      address _eadd = employeemapping[id].e_add;
      return tokenbalance[_eadd];
  }

  function select_objective(uint id) public {
     employeeaddmapping[msg.sender].ob_id=id;
     uint e_id= employeeaddmapping[msg.sender].e_id;
     employeemapping[e_id].ob_id=id;
  }

  function completeobjective() public {
    employeeaddmapping[msg.sender].completed=true;
    employeeaddmapping[msg.sender].objectives_completed+=1;
    uint eid = employeeaddmapping[msg.sender].e_id;
    employeemapping[eid].completed=true;
    employeemapping[eid].objectives_completed+=1;
    uint obid = employeeaddmapping[msg.sender].ob_id;
    createToken(objectivemapping[obid].description);
  }

  function display_me() public view returns(uint eid,string memory ename,string memory edept, uint objectiveid,bool status,uint noofobjectivescompleted) {
    uint eid_ = employeeaddmapping[msg.sender].e_id;
    eid = eid_;
    ename = employeemapping[eid_].name;
    edept = employeemapping[eid_].dept;
    objectiveid = employeemapping[eid_].ob_id;
    status = employeemapping[eid_].completed;
    noofobjectivescompleted = employeemapping[eid_].objectives_completed;
  }

  function createToken(string _tokenURI) public {
      uint256 newTokenId = _getNextTokenId();
      _mint(msg.sender,newTokenId);
      _setTokenURI(newTokenId,_tokenURI);
  }

  function _getNextTokenId() private view returns(uint256){
    return totalSupply().add(1);
  }


}
