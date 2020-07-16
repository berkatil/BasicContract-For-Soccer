pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

struct Date{
    uint8 day;
    uint8 month;
    uint16 year;
}

 abstract contract Person{
    string name;
    uint8 age;
    Date startDate;
    address owner;
    
    function getAge () public view returns(uint8){
         require(msg.sender==owner);
         return age;
    }
    
    function getName () public view returns(string memory){
         return name;
    }
    
    function getStartDate () public view returns(Date memory) {
        return startDate;
    }
    function getSalary() public virtual view returns (uint16);
    
}

contract Researcher is Person{
    uint16 researchSalary;
    string researchArea;
    uint16 numberOfPublications;
    
    constructor(string memory _name, uint8 _age, Date memory _startDate,
    uint16 _researchSalary,string memory _researchArea, uint16 _numberOfPublications) public
    {
        name=_name;
        age=_age;
        startDate=_startDate;
        owner=msg.sender;
        researchSalary=_researchSalary;
        researchArea=_researchArea;
        numberOfPublications=_numberOfPublications;
    }
    
     function getSalary() public virtual override view returns (uint16){
         require(msg.sender==owner);
         return researchSalary;
     }
    
     function getTotalPublications() public view returns (uint16){
         return numberOfPublications;
     }
     
     function getResearchArea() public view returns (string memory){
         return researchArea;
     }
     
     function increaseResearchSalary(uint16 increaseAmount) public{
         require(msg.sender==owner);
         researchSalary+=increaseAmount;
     }
     
     function addPublication() public {
         require(msg.sender==owner);
         numberOfPublications+=1;
     }
    
}

contract Teacher is Person{
    uint16 teachingSalary;
    string givenCourseName;
    uint16 numberOfStudents;
    
    constructor(string memory _name, uint8 _age, Date memory _startDate,
    uint16 _teachingSalary,string memory _courseName, uint16 _numberOfStudents) public
    {
        name=_name;
        age=_age;
        startDate=_startDate;
        owner=msg.sender;
        teachingSalary=_teachingSalary;
        givenCourseName=_courseName;
        numberOfStudents=_numberOfStudents;
    }
    
    function changeCourse(string memory newCourseName,uint16 newNumberOfStudents) public{
        require(msg.sender==owner);
        givenCourseName=newCourseName;
        numberOfStudents=newNumberOfStudents;
    }
    
     function increaseTeachingSalary(uint16 increaseAmount) public{
         require(msg.sender==owner);
         teachingSalary+=increaseAmount;
     }
    
    function getSalary() public virtual override view returns (uint16){
         require(msg.sender==owner);
         return teachingSalary;
     }
     
      function getTotalNumberOfStudentsInTheCourse() public view returns (uint16){
         require(msg.sender==owner);
         return numberOfStudents;
     }
     
     function getGivenCourseName() public view returns (string memory){
         return givenCourseName;
     }
    
}

contract Academician is Teacher,Researcher{
    string title;
    constructor(string memory _name, uint8 _age, Date memory _startDate,
    uint16 _teachingSalary,string memory _courseName, uint16 _numberOfStudents,
    uint16 _researchSalary,string memory _researchArea, uint16 _numberOfPublications,
    string memory _title) Teacher(_name,_age,_startDate,_teachingSalary,_courseName,_numberOfStudents) 
    Researcher(_name,_age,_startDate,_researchSalary,_researchArea,_numberOfPublications) public
    {
       title=_title;
    }
    
    function getSalary() public override(Teacher,Researcher) view returns (uint16){
         require(msg.sender==owner);
         return teachingSalary + researchSalary;
     }
     
     function getTitle() public view returns (string memory){
         return title;
     }
}
