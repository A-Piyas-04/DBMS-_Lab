import java.sql.*;

public class Main {
    // Database credentials
    static final String URL = "jdbc:mysql://localhost:3306/lab-8";
    static final String USER = "root";
    static final String PASSWORD = "12345678";

    public static void main(String[] args) {
        try {
            // 1. Register the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Open a connection
            Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connected to database successfully.");

            // Task 1: Count total transactions for account 49
            Statement stmt1 = con.createStatement();
            ResultSet rs1 = stmt1.executeQuery("SELECT COUNT(*) AS totalTransactions FROM TRANSACTIONS WHERE A_ID = 49");
            if (rs1.next()) {
                System.out.println("Total transactions for account 49: " + rs1.getInt("totalTransactions"));
            }
            rs1.close();
            stmt1.close();

            // Task 2: Count number of credit transactions (TYPE = 0)
            Statement stmt2 = con.createStatement();
            ResultSet rs2 = stmt2.executeQuery("SELECT COUNT(*) AS creditCount FROM TRANSACTIONS WHERE TYPE = 0");
            if (rs2.next()) {
                System.out.println("Total credit transactions: " + rs2.getInt("creditCount"));
            }
            rs2.close();
            stmt2.close();

            // Task 3: List transactions in the last 6 months of 2021
            Statement stmt3 = con.createStatement();
            // Adjust dates based on your database's date format
            String query3 = "SELECT * FROM TRANSACTIONS WHERE DTM BETWEEN '2002-07-01' AND '2021-12-31'";
            ResultSet rs3 = stmt3.executeQuery(query3);
            System.out.println("Transactions from the last 6 months of 2021:");
            while (rs3.next()) {
                // Assuming columns: T_ID, DTM, A_ID, AMOUNT, TYPE
                int t_id = rs3.getInt("T_ID");
                Date dtm = rs3.getDate("DTM");
                int a_id = rs3.getInt("A_ID");
                double amount = rs3.getDouble("AMOUNT");
                int type = rs3.getInt("TYPE");
                System.out.println("T_ID: " + t_id + ", Date: " + dtm + ", Account: " + a_id
                        + ", Amount: " + amount + ", Type: " + (type == 0 ? "Credit" : "Debit"));
            }
            rs3.close();
            stmt3.close();

            // Task 4: Classify accounts into CIP, VIP, OP, and Others
            Statement stmt4 = con.createStatement();
            String query4 = "SELECT A_ID, " +
                    "SUM(CASE WHEN TYPE = 0 THEN AMOUNT ELSE 0 END) - SUM(CASE WHEN TYPE = 1 THEN AMOUNT ELSE 0 END) AS balance, " +
                    "SUM(AMOUNT) AS totalTransacted, " +
                    "CASE " +
                    "WHEN (SUM(CASE WHEN TYPE = 0 THEN AMOUNT ELSE 0 END) - SUM(CASE WHEN TYPE = 1 THEN AMOUNT ELSE 0 END)) > 1000000 " +
                    "AND SUM(AMOUNT) > 5000000 THEN 'CIP' " +
                    "WHEN (SUM(CASE WHEN TYPE = 0 THEN AMOUNT ELSE 0 END) - SUM(CASE WHEN TYPE = 1 THEN AMOUNT ELSE 0 END)) BETWEEN 500000 AND 900000 " +
                    "AND SUM(AMOUNT) BETWEEN 2500000 AND 4500000 THEN 'VIP' " +
                    "WHEN (SUM(CASE WHEN TYPE = 0 THEN AMOUNT ELSE 0 END) - SUM(CASE WHEN TYPE = 1 THEN AMOUNT ELSE 0 END)) < 100000 " +
                    "AND SUM(AMOUNT) < 1000000 THEN 'OP' " +
                    "ELSE 'Other' " +
                    "END AS AccountType " +
                    "FROM TRANSACTIONS GROUP BY A_ID";
            ResultSet rs4 = stmt4.executeQuery(query4);

            // Counters for each category
            int cipCount = 0, vipCount = 0, opCount = 0, otherCount = 0;
            while (rs4.next()) {
                String type = rs4.getString("AccountType");
                switch (type) {
                    case "CIP":
                        cipCount++;
                        break;
                    case "VIP":
                        vipCount++;
                        break;
                    case "OP":
                        opCount++;
                        break;
                    default:
                        otherCount++;
                }
            }
            rs4.close();
            stmt4.close();

            System.out.println("Account classification:");
            System.out.println("CIP: " + cipCount);
            System.out.println("VIP: " + vipCount);
            System.out.println("OP: " + opCount);
            System.out.println("Others: " + otherCount);

            // Close the connection
            con.close();
        } catch (SQLException se) {
            System.out.println("SQL Exception occurred: " + se);
        } catch (ClassNotFoundException cnfe) {
            System.out.println("JDBC Driver not found: " + cnfe);
        }
    }
}
