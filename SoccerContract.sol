pragma solidity ^0.6.11;
pragma experimental ABIEncoderV2;

  struct Player{
        string name;
        uint32 salary;
        string position;
    }
    
   struct Team {
       string name;
       string coach;
       bool exists;
   }
   
   struct License{
       uint256 licenseCode;
       uint16 daysUntilExpiration;
   } 
contract BasicContract{

    mapping(uint256 => Team) Teams;
    
    mapping(uint256 => Player) Players;

    mapping(uint256 => License) Licenses;
    
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
     
     
     function addPlayer (Player memory _player, uint256  _team_code) public returns(uint player_code, uint licenseCode) {
        Team storage team = Teams[_team_code];
        require(team.exists);
        
        uint code = uint(keccak256(abi.encode(_player.name ,now)));
        uint licenseCode= uint(keccak256(abi.encode(_team_code,now)));
        Licenses[code]=License({
            licenseCode : licenseCode,
            daysUntilExpiration : 365
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
}
