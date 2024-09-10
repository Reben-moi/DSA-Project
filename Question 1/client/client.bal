import ballerina/http;
import ballerina/io;
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
    io:println("2. View All Programmes");
    io:println("3. View Programme By Programme Code");
    io:println("4. Update Programme");
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
            string programmeCode = io:readln("Enter Programme Code: ");
            check getProgrammeByCode(programmeClient, programmeCode);
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
}