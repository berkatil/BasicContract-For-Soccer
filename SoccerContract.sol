pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;

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
       uint256 licenseCode;
       Date contractEndDate;
       uint256 teamCode;
   } 
   
   struct TransferInfo{
       uint32 fee;
       uint256 fromTeam;
       uint256 toTeam;
       Date date;
   }
   
contract BasicContract{

    mapping(uint256 => Team) Teams;
    
    mapping(uint256 => Player) Players;

    mapping(uint256 => License) Licenses;
    
    mapping(uint256 => TransferInfo[]) Transfers;
    
     function addTeam (string memory _name, string memory _coach) public  returns(uint team_code){
        uint code = uint(keccak256(abi.encode(_name ,now)));
       
        Teams[code] = Team({
           name : _name,
           coach : _coach,
           exists: true
        });
        
        return code;
     }
     
     function getLicense(uint256 _player_code) public view returns(License memory){
         return Licenses[_player_code];
     }
     
     function addPlayer (Player memory _player, uint256  _team_code, Date memory _contract_end_date) public returns(uint player_code, uint licenseCode) {
        Team storage team = Teams[_team_code];
        require(team.exists);
        
        uint code = uint(keccak256(abi.encode(_player.firstName ,now)));
        uint createdLicenseCode = uint(keccak256(abi.encode(_team_code,now)));
        _contract_end_date.valid=true;
        
        Licenses[code]=License({
            licenseCode : createdLicenseCode,
            contractEndDate : _contract_end_date,
            teamCode : _team_code
        });
        Players[code] = _player;
        
        return (code,licenseCode);
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
     Date memory _new_contract_end_date) public {
         _transfer_date.valid=true;
           Transfers[_player_code].push(TransferInfo({
               fee : _transfer_fee,
               fromTeam : _from_team,
               toTeam : _to_team,
               date : _transfer_date
           })); 
           
           License storage license = Licenses[_player_code];
           license.contractEndDate=_new_contract_end_date;
           license.teamCode=_to_team;
     }
     
     function releasePlayer(uint256 _player_code) public{
         License storage license = Licenses[_player_code];
         license.contractEndDate.valid=false;
         license.teamCode=0;
         Player storage player = Players[_player_code];
         player.salary=0;
     }
     
     function signContract(uint256 _player_code, uint32 _salary, uint256 _to_team,Date memory _new_contract_end_date) public{
         License storage license = Licenses[_player_code];
         require(license.teamCode==0);
         require(!license.contractEndDate.valid);
         _new_contract_end_date.valid=true;
         license.contractEndDate=_new_contract_end_date;
         license.teamCode=_to_team;
         Player storage player = Players[_player_code];
         player.salary=_salary;
     }
}
