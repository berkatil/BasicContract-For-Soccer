pragma solidity ^0.4.0;


contract Person {
    string name;
    uint8 age;
    string startDate;
    address owner;
    
    
    modifier onlyOwner() {
        if (msg.sender != owner)
            throw;
        _;
    }
    
    function getAge () external onlyOwner  returns(uint8){
         return age;
    }
    
    function getName () public  returns(string memory){
         return name;
    }
    
   function getStartDate () public  returns(string memory) {
        return startDate;
    }
    function getSalary()external  returns (uint16);
    
}

contract Researcher is Person{
    uint16 researchSalary;
    string researchArea;
    uint16 numberOfPublications;
    
    function Researcher (string _name, uint8 _age,string _startDate,
    uint16 _researchSalary,string _researchArea, uint16 _numberOfPublications) public
    {
        name=_name;
        age=_age;
        startDate=_startDate;
        owner=msg.sender;
        researchSalary=_researchSalary;
        researchArea=_researchArea;
        numberOfPublications=_numberOfPublications;
    }
    
     function getSalary() external onlyOwner returns (uint16){
         return researchSalary;
     }
    
     function getTotalPublications() public  returns (uint16){
         return numberOfPublications;
     }
     
     function getResearchArea() public returns (string memory){
         return researchArea;
     }
     
     function increaseResearchSalary(uint16 increaseAmount) external onlyOwner{
         researchSalary+=increaseAmount;
     }
     
     function addPublication() external onlyOwner {
         numberOfPublications+=1;
     }
    
}

contract Teacher is Person{
    uint16 teachingSalary;
    string givenCourseName;
    uint16 numberOfStudents;
    
    function Teacher(string memory _name, uint8 _age,string _startDate,
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
    
    function changeCourse(string  newCourseName,uint16 newNumberOfStudents) external onlyOwner{
        givenCourseName=newCourseName;
        numberOfStudents=newNumberOfStudents;
    }
    
     function increaseTeachingSalary(uint16 increaseAmount) external onlyOwner{
         teachingSalary+=increaseAmount;
     }
    
    function getSalary() external onlyOwner  returns (uint16){
         return teachingSalary;
     }
     
      function getTotalNumberOfStudentsInTheCourse() external onlyOwner  returns (uint16){
         return numberOfStudents;
     }
     
     function getGivenCourseName() public  returns (string memory){
         return givenCourseName;
     }
    
}

contract Academician is Teacher,Researcher{
    string title;
    function Academician(string memory _name, uint8 _age,string _startDate,
    uint16 _teachingSalary,string memory _courseName, uint16 _numberOfStudents,
    uint16 _researchSalary,string memory _researchArea, uint16 _numberOfPublications,
    string memory _title) Teacher(_name,_age,_startDate,_teachingSalary,_courseName,_numberOfStudents) 
    Researcher(_name,_age,_startDate,_researchSalary,_researchArea,_numberOfPublications) public
    {
       title=_title;
    }
    
    function getSalary() external onlyOwner  returns (uint16){
         return teachingSalary + researchSalary;
     }
     
     function getTitle() public returns (string memory){
         return title;
     }
}
