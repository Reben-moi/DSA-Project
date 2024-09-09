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

table<Programme> key(programmeCode) programmeTable = table [];

service /programmes on new http:Listener(8080) {
resource function post addProgramme(@http:Payload Programme programme) returns string {
    io:println(programme);
    error? err = programmeTable.add(programme);
    if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `${programme.programmeCode} saved successfully`;
    }
resource function get getAllProgrammes() returns table<Programme> key(programmeCode) {
        return programmes;
    }
  resource function put updateProgrammeDetails(@http:Payload Lecturer lecturer) returns string {
        io:println(programme);
        error? err = programmeTable.put(programme);
        if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `${programme.programmeCode} saved successfully`;
    }
}