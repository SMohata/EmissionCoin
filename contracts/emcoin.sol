pragma solidity ^0.5.2;
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

contract emcoin {
    using SafeMath for uint;
    string  public name = "EmissionCoin";
    string  public symbol = "EMC";
    string  public standard = "erc20";
    uint256 public decimalPlaces = 4;
    address _owner;
    uint public oid=0;


    constructor() public{
        _owner = msg.sender;
    }

    struct employee {
        uint e_id;
        string name;
        string dept;
        address e_add;
        uint obid;
        bool completed;
        uint objectives_completed;
    }

    struct objective {
        uint o_id;
        string description;
    }

    uint[] obj_arr;

    mapping (address => uint) public balanceOf;
    mapping (uint => objective) objectivemapping;
    mapping (uint => employee) employeemapping;
    mapping (address => uint) employeeaddmapping;

    function get_next_id() public {
        oid+=1;
    }

    function add_employee(uint eid, string memory ename,string memory edept) public {
        employeemapping[eid]=employee(eid,ename,edept,msg.sender,0,false,0);
        employeeaddmapping[msg.sender]=eid;
        balanceOf[msg.sender]=0;
    }

    function add_objective(string memory des) public {
        require(msg.sender==_owner);
        get_next_id();
        objectivemapping[oid]=objective(oid,des);
        obj_arr.push(oid);
    }

    function get_rand_no() internal view returns(uint) {
        uint len= obj_arr.length;
        uint randomnumber = uint(keccak256(abi.encodePacked(now, msg.sender))) % len;
        return randomnumber;
    }


    function assign_objective() public {
        uint eid_ = employeeaddmapping[msg.sender];
        uint randno= get_rand_no();
        employeemapping[eid_].obid=randno;
        employeemapping[eid_].completed=false;
    }

    function completeobjective() public {
        uint eid_ = employeeaddmapping[msg.sender];
        employeemapping[eid_].completed=true;
        balanceOf[msg.sender]+=100;
        employeemapping[eid_].objectives_completed+=1;
    }

    function display_me() public view returns(uint eid,string memory ename,string memory edept, uint objectiveid,bool status,uint noofobjectivescompleted) {
        uint eid_ = employeeaddmapping[msg.sender];
        eid = eid_;
        ename = employeemapping[eid_].name;
        edept = employeemapping[eid_].dept;
        objectiveid = employeemapping[eid_].obid;
        status = employeemapping[eid_].completed;
        noofobjectivescompleted = employeemapping[eid_].objectives_completed;
    }

    function display_objectivearr() public view returns(uint[] memory obarr) {
        obarr= obj_arr;
    }

    function getmybalance()public view returns(uint) {
        return balanceOf[msg.sender];
    }

}

