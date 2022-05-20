// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HealthCare {

    mapping(address => uint) authCaller;
    mapping(address => string) userType;
    mapping(address => Doctor) docData;
    mapping(address => MedicalForm) mediData;
    mapping(address => Patient) patData;

    constructor() public {
        authCaller[msg.sender] = 1;
    }

    struct Doctor {
        address docAddr;
        string hospital;
        address[] patient;
    }

    struct Patient {
        address patAddr;
        string name;
        string age;
    }

    struct MedicalForm {
        address patientAddr;
        string patientName;
        string patientAge;
        string patientWeight;
        string patientHeight;
        string symptom;
        string description;
        uint state;
    }

    // event
    event DoctorAdd(address doctorAddr);
    
    // * Doctor *
    function addDoctor(address doctorAddr, string memory _hospital) public returns(bool) {
        require(keccak256(abi.encodePacked(userType[msg.sender]))
        == keccak256(abi.encodePacked("")));

        userType[msg.sender] = 'doctor';
        docData[msg.sender].docAddr = doctorAddr;
        docData[msg.sender].hospital = _hospital;
        emit DoctorAdd(msg.sender);
        return true;
    }

    // CRUD Patient Data

    // Create
    function addPatientData(address _patientAddr, string memory _patientName, string memory _patientAge,
    string memory _patientWeight, string memory _patientHeight, string memory _symptom, string memory _description) 
    public returns(string memory) {
        require(keccak256(abi.encodePacked(userType[msg.sender])) == keccak256(abi.encodePacked("doctor")));

        mediData[_patientAddr].patientAddr = _patientAddr;
        mediData[_patientAddr].patientName = _patientName;
        mediData[_patientAddr].patientAge = _patientAge;
        mediData[_patientAddr].patientWeight = _patientWeight;
        mediData[_patientAddr].patientHeight = _patientHeight;
        mediData[_patientAddr].symptom = _symptom;
        mediData[_patientAddr].description = _description;
        // CRUD state
        mediData[_patientAddr].state = 0; 
        
        docData[msg.sender].patient.push(_patientAddr);
        return mediData[_patientAddr].patientName;
    }

    // Read
    function readPatientData(address _patientAddr) public view returns(MedicalForm memory) {
        return mediData[_patientAddr];
    }

    // Update
    function updatePatientData(address _patientAddr, string memory _patientName, string memory _patientAge,
    string memory _patientWeight, string memory _patientHeight, string memory _symptom, string memory _description)
    public returns(bool) {
        require(keccak256(abi.encodePacked(userType[msg.sender])) == keccak256(abi.encodePacked("doctor")));

        mediData[_patientAddr].patientAddr = _patientAddr;
        mediData[_patientAddr].patientName = _patientName;
        mediData[_patientAddr].patientAge = _patientAge;
        mediData[_patientAddr].patientWeight = _patientWeight;
        mediData[_patientAddr].patientHeight = _patientHeight;
        mediData[_patientAddr].symptom = _symptom;
        mediData[_patientAddr].description = _description;

        return true;
    }

    // Delete
    function deletePatientData(address _patientAddr) public returns(bool) {
        require(keccak256(abi.encodePacked(userType[msg.sender])) == keccak256(abi.encodePacked("doctor")));

        uint index;

        for(uint i = 0; i < docData[msg.sender].patient.length; i++) {
            if(docData[msg.sender].patient[i] == _patientAddr) {
                index = i;
            }
        }

        for(uint i = index; i < docData[msg.sender].patient.length - 1; i++) {
            docData[msg.sender].patient[i] = docData[msg.sender].patient[i + 1];
        }

        docData[msg.sender].patient.pop();
        delete mediData[_patientAddr];

        return true;
    }

    // paitent
    function addPatient(address _patAddr, string memory _name, string memory _age) public returns (bool) {
        require(keccak256(abi.encodePacked(userType[msg.sender])) == keccak256(abi.encodePacked("")));

        userType[msg.sender] = "patient";
        patData[msg.sender].patAddr = _patAddr;
        patData[msg.sender].name = _name;
        patData[msg.sender].age = _age;

        return true;
    }

    // get patient list
    function getPatientList(address _doctorAddr) view public returns (address[] memory){
        require(keccak256(abi.encodePacked(userType[msg.sender])) == keccak256(abi.encodePacked("doctor")));
        return docData[_doctorAddr].patient;
    }

    // get user
    function getUser(address userAddr) view public returns(string memory) {
        return userType[userAddr];
    }
}