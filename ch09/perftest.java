import java.sql.*;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.io.*;

public class perftest
{
  public static void main (String arr[]) throws Exception
  {
    DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
    Connection con = DriverManager.getConnection
                  ("jdbc:oracle:thin:@//localhost.localdomain:1521/PDB1", "eoda", "foo");
    Integer iters = new Integer(arr[0]);
    Integer commitCnt = new Integer(arr[1]);
    con.setAutoCommit(false);
    doInserts( con, 1, 1 );
    Statement stmt = con.createStatement ();
        stmt.execute( "begin dbms_monitor.session_trace_enable(waits=>true); end;" );
    doInserts( con, iters.intValue(), commitCnt.intValue() );
    con.close();
  }
  static void doInserts(Connection con, int count, int commitCount )
  throws Exception
  {
    PreparedStatement ps =
       con.prepareStatement
       ("insert into test " +
        "(id, code, descr, insert_user, insert_date)"
        + " values (?,?,?, user, sysdate)");
    int  rowcnt = 0;
    int  committed = 0;
    for (int i = 0; i < count; i++ )
    {
      ps.setInt(1,i);
      ps.setString(2,"PS - code" + i);
      ps.setString(3,"PS - desc" + i);
      ps.executeUpdate();
      rowcnt++;
      if ( rowcnt == commitCount )
      {
        con.commit();
        rowcnt = 0;
        committed++;
      }
    }
    con.commit();
    System.out.println
    ("pstatement rows/commitcnt = " + count + " / " +  committed );
  }
}
