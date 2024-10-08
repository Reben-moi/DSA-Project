import ballerina/http;
import ballerina/io;
import ballerina/time;

type Course record {
    string course_name;
    string course_code;
    int nqf_level;
    string[] fun_facts = [];
};

type Programme record {| 
    readonly string code;
    string faculty;
    string qualification_title;
    int nqf_level;
    string registration_date;
    int reg_year;
    Course[] courses;
    string description = "";
|};

table<Programme> key(code) programme_table = table [];

string[] fun_phrases = [
    "Woohoo! ", 
    "Awesome sauce! ", 
    "Holy guacamole! ", 
    "Bazinga! ", 
    "Cowabunga! "
];

function getRandomIndex(int max) returns int {
    time:Utc currentTime = time:utcNow();
    int nanoTime = currentTime[0];
    return nanoTime % max;
}

service /programmeManagament on new http:Listener(7500) {

    resource function get all() returns Programme[] {
        io:println("🎉 Fetching all programmes!");
        return programme_table.toArray();
    }

    resource function get getByCode/[string code]() returns Programme|string {
        Programme? programme = programme_table.get(code);
        if programme is Programme {
            io:println("🔍 Found the programme you requested!");
            return programme;
        }
        return "😢 We're finding it very hard to locate the program, try again later!";
    }

    resource function get getByfaculty/[string faculty]() returns Programme[] {
        io:println("🏫 Searching for programmes in the " + faculty + " faculty. ");
        Programme[] result = from Programme programme in programme_table
                             where programme.faculty == faculty
                             select programme;
        return result;
    }

    resource function post add_new_programme(Programme programme) returns string {
        programme_table.add(programme);
        string response = fun_phrases[getRandomIndex(fun_phrases.length())] + 
                          "The programme '" + programme.qualification_title + "' has been registered successfully";
        io:println("🎊 " + response);
        return response;
    }

    resource function put update_programme/[string code](Programme programme) returns string {
        if (programme_table.hasKey(code)) {
            programme_table.put(programme);
            string response = "The programme has been updated successfully!";
            io:println("💅 " + response);
            return response;
        }
        return "😢 We're finding it very hard to locate the program, try again later!";
    }

    resource function get getDueYear() returns Programme[] {
        time:Utc currentTime = time:utcNow();
        time:Civil currentTime_Civil = time:utcToCivil(currentTime);
        int year = currentTime_Civil.year;
        table<Programme> due_programme = table[];
        foreach Programme programme in programme_table {
            int programme_year = programme.reg_year;
            if((year - programme_year) >= 5){
                due_programme.add(programme);
            }
        }
        return due_programme.toArray();
    }

    resource function delete delete_programme/[string code]() returns string {
        if (programme_table.hasKey(code)) {
            Programme result = programme_table.remove(code);
            string response = "The programme '" + result.qualification_title + "' has been deleted";
            io:println("🔮 " + response);
            return response;
        }
        return "🕵️ Hmm... We couldn't find this programme.";
    }

    resource function get random_fun_fact/[string code]() returns string {
        Programme? programme = programme_table[code];
        if programme is Programme {
            if programme.courses.length() > 0 {
                int randomCourseIndex = getRandomIndex(programme.courses.length());
                Course randomCourse = programme.courses[randomCourseIndex];
                if randomCourse.fun_facts.length() > 0 {
                    int randomFactIndex = getRandomIndex(randomCourse.fun_facts.length());
                    return string `🎨 Fun fact about ${randomCourse.course_name}: ${randomCourse.fun_facts[randomFactIndex]}`;
                }
                return "🤔 Oops! We haven't added any fun facts to this course yet. It's a mystery!";
            }
            return "📚 This programme is shy and doesn't have any courses to share fun facts about!";
        }
        return "🕵️ Programme not found.";
    }
}
