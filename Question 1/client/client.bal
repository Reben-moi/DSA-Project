import ballerina/io;
import ballerina/http;
import ballerina/time;
 
type Programme record {
   readonly string programmeCode;
    string nqfLevel;
    string faculty;
    string department;
    string title;
    time:Date registrationDate;
    Course[] courses;
};

type Course record {
    string courseCode;
    string courseName;
    string nqfLevel;
};

public function main() returns error? {
    http:Client programmeClient = check new ("localhost:8080/programmes");

    io:println("1. Add Programme");
    io:println("2. Retrieve a list of All Programme within Programme Development Unit");
    io:println("3. Update an exist if Programme By Programme Code");
    io:println("4. View Specific Programme by programme code");
    io:println("5. Delete Programme By Programme Code");
    io:println("6. Retrieve all Programmme Due For Review");
    io:println("7. Retrieve Programmes From Same Faculty");
    string option = io:readln("Choose an option: ");

match option {
        
        "1" => {
            Programme programme = {};
            programme.programmeCode = io:readln("Enter Programme Code: ");   
            programme.title = io:readln("Enter Programme Title: ");          
            programme.nqfLevel = io:readln("Enter NQF Level: ");           
            programme.faculty = io:readln("Enter Faculty Name: ");           
            programme.department = io:readln("Enter Department Name: ");     
            programme.registrationDate = io:readln("Enter Registration Date (YYYY-MM-DD): "); 
            
            
            programme.courses = [
                {
                    courseCode: io:readln("Enter Course Code: "),            
                    courseName: io:readln("Enter Course Name: "),            
                    nqfLevel: io:readln("Enter Course NQF Level: ")          
                }
            ];

            check addProgramme(programmeClient, programme); 
        }
        "2" => {
            check getAllProgrammes(programmeClient);
        }        
        
        "3" => {
             Programme programme = {};
            programme.programmeCode = io:readln("Enter Programme Code: ");   
            programme.title = io:readln("Enter Programme Title: ");          
            programme.nqfLevel = io:readln("Enter NQF Level: ");           
            programme.faculty = io:readln("Enter Faculty Name: ");           
            programme.department = io:readln("Enter Department Name: ");     
            programme.registrationDate = io:readln("Enter Registration Date (YYYY-MM-DD): "); 
            
            
            programme.courses = [
                {
                    courseCode: io:readln("Enter Course Code: "),            
                    courseName: io:readln("Enter Course Name: "),            
                    nqfLevel: io:readln("Enter Course NQF Level: ")          
                }
            ];

            check updateProgramme(programmeClient, programme); 
        }
        "4" => {
            string programmeCode = io:readln("Enter Programme Code: ");
            check getProgrammeByCode(programmeClient, programmeCode);
        }
        "5" => {
             string programmeCode = io:readln("Enter programme code: ");
            check deleteProgrammeByCode(programmeClient, programmeCode);
        }
        "6" => {
             check getProgrammesDueForReview(programmeClient);
        }
        "7" => {
            string faculty = io:readln("Enter Faculty: ");
            check getAllProgrammesInFaculty(programmeClient, faculty);
        }
       _ => {
            io:println("Invalid Key");
            check main();
        }    
    }
}


public function addProgramme(http:Client http, Programme programme) returns error? {
    if (http is http:Client) {
        string message = check http->/addProgramme.post(programme);
        io:println(message);
    }
}

public function getAllProgrammes(http:Client http) returns error? {
    if (http is http:Client) {
        table<Programme> programmeTable = check http->/getAllProgrammes.get();
        foreach Programme programme in programmeTable {
            io:println("--------------------------");
            io:println("Programme Code: ", programme.programmeCode);
            io:println("Programme Title: ", programme.title);
            io:println("NQF Level: ", programme.nqfLevel);
            io:println("Programme Faculty: ", programme.faculty);
            io:println("Department Name: ", programme.department);
            io:println("Registration Date: ", programme.registrationDate);
        }
    }
}
public function updateProgramme(http:Client http, Programme programme) returns error? {
    if (http is http:Client) {
        string message = check http->/updateProgrammeDetails.put(programme);
        io:println(message);
    }
 }
    public function getProgrammeByCode(http:Client http, string programmeCode) returns error? {
    if (http is http:Client) {
        Programme|string programme = check http->/getProgrammeByCode.get(programmeCode = programmeCode);
        if (lecturer is Lecturer) {
            io:println("--------------------------");
            io:println("Programme Code: ", programme.programmeCode);
            io:println("Programme Title: ", programme.title);
            io:println("NQF Level: ", programme.nqfLevel);
            io:println("Programme Faculty: ", programme.faculty);
            io:println("Department Name: ", programme.department);
            io:println("Registration Date: ", programme.registrationDate);
        } else {
            io:println(programme);
        }
    }
}

 public function deleteProgrammeByCode(http:Client http, string programmeCode) returns error? {
    if (http is http:Client) {
        string message = check http->/deleteProgrammeByCode.get(programmeCode = programmeCode);
        io:println(message);
    }
}

public function getProgrammesDueForReview(http:Client http) returns error? {
    table<Programme> programmes = check http->get("/getProgrammesDueForReview");
    
    if (programmes.isEmpty) {
        io:println("No programmes due for review.");
    } else {
        foreach Programme programme in programmes {
            io:println("--------------------------");
            io:println("Programme Code: ", programme.programmeCode);
            io:println("Programme Title: ", programme.title);
            io:println("NQF Level: ", programme.nqfLevel);
            io:println("Programme Faculty: ", programme.faculty);
            io:println("Department Name: ", programme.department);
            io:println("Registration Date: ", programme.registrationDate);
        }
    }
}


public function getAllProgrammesInFaculty(http:Client http, string faculty) returns error? {
    if (http is http:Client) {
        table<Programme> programmes = check http->/getAllProgrammesInFaculty.get({faculty});
        foreach programme programme in programmes {
            io:println("--------------------------");
            io:println("Programme Code: ", programme.programmeCode);
            io:println("Programme Title: ", programme.title);
            io:println("NQF Level: ", programme.nqfLevel);
            io:println("Programme Faculty: ", programme.faculty);
            io:println("Department Name: ", programme.department);
            io:println("Registration Date: ", programme.registrationDate);
        }
    }
}
