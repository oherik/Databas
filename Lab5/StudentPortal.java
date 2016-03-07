/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */
import java.sql.*; // JDBC stuff.
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.

public class StudentPortal
{
    /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "tda357_053";
    static final String PASSWORD = "UqkUyZpd";

    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage () {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }

    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
    public static void main(String[] args) throws Exception
    {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://ate.ita.chalmers.se/";
            Properties props = new Properties();
            props.setProperty("user",USERNAME);
            props.setProperty("password",PASSWORD);
            Connection conn = DriverManager.getConnection(url, props);

            String student = args[0]; // This is the identifier for the student.

            Console console = System.console();
            usage();
            System.out.println("Welcome!");
            while(true) {
                String mode = console.readLine("? > ");
                String[] cmd = mode.split(" +");
                cmd[0] = cmd[0].toLowerCase();
                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
                    /* Information mode */
                    getInformation(conn, student);
                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Register student mode */
                    registerStudent(conn, student, cmd[1]);
                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Unregister student mode */
                    unregisterStudent(conn, student, cmd[1]);
                } else if ("quit".startsWith(cmd[0])) {
                    break;
                } else usage();
            }
            System.out.println("Goodbye!");
            conn.close();
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
    }

    /* Given a student identification number, ths function should print
     * - the name of the student, the students national identification number
     *   and their issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to. (queue position if the student is waiting for the course)
     * - the number of mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, String student) throws SQLException
    {
        Statement st = conn.createStatement();

        ResultSet rs = st.executeQuery("SELECT * FROM StudentsFollowing WHERE NationalID = '" + student + "'");
        while(rs.next()){
            System.out.println("Name:\t\t" + rs.getString("Name"));
            System.out.println("National ID:\t" + rs.getString("NationalID"));
            System.out.println("School ID:\t" + rs.getString("SchoolID"));
            System.out.println("Programme:\t" + rs.getString("Programme"));
            String branch = rs.getString("Branch");
            if(branch != null && !branch.equals(""))
                System.out.println("Branch:\t" + branch);
        }
        rs.close();

        rs = st.executeQuery("SELECT * FROM FinishedCourses WHERE Student ='" + student + "'");
        System.out.println("\nRead courses (name (code), credits: grade)");
        while(rs.next()){
            System.out.println(" " + rs.getString("CourseName") + " (" + rs.getString("CourseCode") + "), " +
            rs.getString("Credit") +"p: "+ rs.getString("Grade"));
        }
        rs.close();

        rs = st.executeQuery("SELECT * FROM Registrations WHERE Student = '" + student + "'");
        System.out.println("\nRegistered courses (name (code): status):");
        while(rs.next()){
            String status =  rs.getString("Status");
            String courseCode = rs.getString("CourseCode");
            System.out.print(" " + rs.getString("CourseName") + " (" + courseCode + "): " + 
                status);
            if(status.equals("Waiting")){
                //Our "CourseQueuePosition is called IsOnWaitingList"
                ResultSet waiting = st.executeQuery("SELECT QueuePos FROM IsOnWaitingList WHERE Student = '" + student + "' AND "+
                    "RestrictedCourse = '" +courseCode + "'");
                while(waiting.next())
                    System.out.print(" as nr " + waiting.getString(1));
                waiting.close();
            }
            System.out.print("\n");
        }
        rs.close();

        st.close();

        // TODO: Your implementation here
    }

    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, String student, String course)
    throws SQLException
    {
        // TODO: Your implementation here
    }

    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, String student, String course)
    throws SQLException
    {
        // TODO: Your implementation here
    }
}
