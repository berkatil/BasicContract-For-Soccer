pragma solidity ^0.6.0;

contract Education {
    
    string private firstName;
    string private lastName;
    uint16 private universityGraduationYear;
    string private university;
    string private highSchool;
    string private major;
    
    constructor(string memory _firstName,string memory _lastName,
    string memory _university,string memory _highSchool,string memory _major,
    uint16 _universityGraduationYear) public
    {
        firstName = _firstName;
        lastName = _lastName;
        universityGraduationYear = _universityGraduationYear;
        university = _university;
        highSchool = _highSchool;
        major = _major;
    }
    
     function getName() public view returns (string memory){
         return string(abi.encodePacked(firstName, " ", lastName));
     }
     
     function getUniversityName() public view returns (string memory){
         return university;
     }
     
     function getHighSchoolName() public view returns (string memory){
         return highSchool;
     }
     
     function getMajor() public view returns (string memory){
         return major;
     }
     
     function getUniversityGraduationYear() public view returns (uint16){
         return universityGraduationYear;
     }
}