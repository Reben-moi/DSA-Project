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
        return programmeTable;
    }
 
 resource function get getProgrammeByCode(string programmeCode) returns Programme|error {
        foreach Programme programme in programmeTable {
            if (programme.programmeCode === programmeCode) {
                return programme;
            }
        }
       return error("Programme not found with code: " + programmeCode);
    }
  resource function put updateProgrammeDetails(@http:Payload Programme programme) returns string {
        io:println(programme);
        error? err = programmeTable.put(programme);
        if (err is error) {
            return string `Error, ${err.message()}`;
        }
        return string `${programme.programmeCode} saved successfully`;
    }

    resource function get getProgrammeByFaculty(string faculty) returns Programme|error {
        foreach Programme programme in programmeTable {
            if (programme.faculty === faculty) {
                return programme;
            }
        }
        return error("Programme not found in faculty: " + faculty);
    }

resource function delete deleteProgrammeByCode(string programmeCode) returns string {
        table<Programme> tempProgrammeTable = table [];
        boolean programmeFound = false;

        foreach Programme programme in programmeTable {
            if (programme.programmeCode !== programmeCode) {
                tempProgrammeTable.add(programme);
            } else {
                programmeFound = true;
            }
        }

        if (!programmeFound) {
            return programmeCode + " not found.";
        }

        programmeTable = <table<Programme> key(programmeCode)>tempProgrammeTable;
        return programmeCode + " successfully deleted";
    }
    
function isDueForReview(time:Date registrationDate) returns boolean {
    time:Date currentDate = time:currentDate();
    int diffYears = time:yearsBetween(registrationDate, currentDate);
    return diffYears >= 4;
}

resource function get getProgrammesDueForReview() returns Programme[] {
    Programme[] dueForReviewProgrammes = [];

    foreach Programme programme in programmeTable {
        if (isDueForReview(programme.registrationDate)) {
            dueForReviewProgrammes.push(programme);
        }
    }

    return dueForReviewProgrammes;
}

resource function get getProgrammeByFaculty(string faculty) returns Programme[]|error {
    Programme[] facultyProgrammes = [];

    foreach Programme programme in programmeTable {
        if (programme.faculty == faculty) {
            facultyProgrammes.push(programme);
        }
    }

    if (facultyProgrammes.length() == 0) {
        return error("No programmes found in faculty: " + faculty);
    }

    return facultyProgrammes;
}    
}