pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/EnumerableSet.sol";

  struct Player{
        string firstName;
        string lastName;
        uint32 salary;
        string salaryCurrency;
    }
    
    struct Date{
    uint8 day;
    uint8 month;
    uint16 year;
    bool valid;
}

   struct Team {
       string name;
       string coach;
       bool exists;
   }
   
   struct License{
       Date contractEndDate;
   } 
   
   struct TransferInfo{
       uint32 fee;
       uint256 fromTeam;
       uint256 toTeam;
       Date date;
   }
   
contract BasicContract{
    
using EnumerableSet for EnumerableSet.UintSet;
    mapping(uint256 => Team) Teams;
    
    mapping(uint256 => Player) Players;

    mapping(uint256 => License) Licenses; // license code=< license struct
    
    mapping(uint256 => EnumerableSet.UintSet) TeamLicences; // teamcode => set of licences
    
    mapping(uint256 => TransferInfo[]) Transfers;
    
    event TeamAddition(
        address indexed _from,
        string indexed _name,
        uint _code
    );
    event PlayerAddition(
      address indexed _from,
      uint _licenseCode,
      uint _playerCode
    );    
    
     function addTeam (string memory _name, string memory _coach) public {
        uint code = uint(keccak256(abi.encode(_name ,now)));
       
        Teams[code] = Team({
           name : _name,
           coach : _coach,
           exists: true
        });
        
        emit TeamAddition(msg.sender,_name,code);
     }
     
    function getLicense(uint256 _license_code) public view returns(License memory){
         return Licenses[_license_code];
     }
     
     function addPlayer (Player memory _player, uint256  _team_code, Date memory _contract_end_date) public {
        Team storage team = Teams[_team_code];
        require(team.exists);
        
        uint code = uint(keccak256(abi.encode(_player.firstName ,now)));
        uint createdLicenseCode = uint(keccak256(abi.encode(_team_code,now)));
        _contract_end_date.valid=true;
        
        License memory player_license =License({
            contractEndDate : _contract_end_date
        });
        Licenses[createdLicenseCode]=player_license;
        TeamLicences[_team_code].add(createdLicenseCode);
        Players[code] = _player;
        
        emit PlayerAddition(msg.sender,createdLicenseCode,code);
    
     }
     
     function getPlayer (uint256 _code) public view returns(Player memory){
        return Players[_code];
    }
    
     function getTeam (uint256 _code) public view returns(Team memory){
        Team storage team = Teams[_code];
        require(team.exists);
        
        return team;
    }
     
     function increasePlayerSalary(uint256 _code,uint32 _increaseAmount) public{
          Player storage player=Players[_code];
          player.salary+=_increaseAmount;
     }
     
     function transferPlayer(uint256 _player_code, uint256 _from_team,uint256 _to_team, uint32 _transfer_fee, Date memory _transfer_date,
     Date memory _new_contract_end_date, uint _license_code) public {
         _transfer_date.valid=true;
           Transfers[_player_code].push(TransferInfo({
               fee : _transfer_fee,
               fromTeam : _from_team,
               toTeam : _to_team,
               date : _transfer_date
           })); 
          
         License storage license = Licenses[_license_code];
         license.contractEndDate=_new_contract_end_date;
         
           TeamLicences[_from_team].remove(_license_code);
           TeamLicences[_to_team].add(_license_code);
     }
     
     function releasePlayer(uint256 _team_code,uint256 _player_code,uint256 _license_code) public{
         License storage license = Licenses[_license_code];
         license.contractEndDate.valid=false;
         Player storage player = Players[_player_code];
         player.salary=0;
         TeamLicences[_team_code].remove(_license_code);
     }
     
     function signContract(uint256 _license_code,uint256 _player_code, uint32 _salary, uint256 _to_team,Date memory _new_contract_end_date) public{
         License storage license = Licenses[_license_code];
         require(!license.contractEndDate.valid);
         _new_contract_end_date.valid=true;
         license.contractEndDate=_new_contract_end_date;
         Player storage player = Players[_player_code];
         player.salary=_salary;
         TeamLicences[_to_team].add(_license_code);
     }
}
